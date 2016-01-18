# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  username               :string           not null, unique
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  eula_id                :integer
#  first_name             :string
#  last_name              :string
#  company                :string
#  rating                 :decimal(, )      default(0.0)
#  status                 :integer          default(0), not null
#  user_type              :integer          default(0), not null
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  tokens                 :json
#  number_of_ratings      :integer          default(0)
#  uuid_iphone            :string
#  device_token           :string
#  device_type            :string

class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  mount_uploader :profile_picture, ProfilePictureUploader
  enum user_type: [:staff, :administrator, :customer]
  enum status: [:active, :banned]
  enum device_type: [:ios, :android]
  # manual paper trail initialization
  class_attribute :version_association_name
  self.version_association_name = :version

  # The version this instance was reified from.
  attr_accessor self.version_association_name

  belongs_to :eula
  belongs_to :privacy
  has_many :ratings
  has_many :rated_on_ratings, class_name: 'Rating', foreign_key: 'rated_on_id'
  has_many :blocked_users
  has_many :jobs
  has_many :notifications
  has_many :chats, foreign_key: 'from_user_id'
  has_many :user_conversations, class_name: 'Conversation', foreign_key: "from_user_id"
  has_many :conversation_participants
  has_many :community_conversations, through: :conversation_participants, foreign_key: 'user_id'

  validates :username, format: { with: /\A[a-zA-Z0-9_]+\Z/ }
  validates_presence_of :username, :email
  validates_presence_of :company, if: Proc.new { |user| user.staff? }
  validates_uniqueness_of :username, :email


  attr_accessor :status_change_comment

  after_update :log_user_events
  after_create :add_to_mailchimp
  after_update :update_on_mailchimp, if: :mailchimp_related_fields_updated?
  after_destroy :delete_from_mailchimp

  def log_user_events
    attr = {item_type: 'User', item_id: self.id, object: PaperTrail.serializer.dump(self.attributes)}
    if self.changed_attributes.keys.include?('sign_in_count')
      PaperTrail::Version.create(attr.merge(event: 'Login'))
    elsif self.changed_attributes.keys.include?('reset_password_sent_at')
      PaperTrail::Version.create(attr.merge(event: 'Password reset requested'))
    elsif self.changed_attributes.keys.include?('reset_password_token') && self.self.reset_password_token.nil?
      PaperTrail::Version.create(attr.merge(event: 'Password reset'))
    elsif self.changed_attributes.keys.include?('current_sign_in_at') && self.current_sign_in_at.nil?
      PaperTrail::Version.create(attr.merge(event: 'Logout'))
    elsif self.changed_attributes.keys.include?('status')
      PaperTrail::Version.create(attr.merge({event: self.status.humanize, whodunnit: PaperTrail.whodunnit, comment: self.status_change_comment}))
    end
  end

  def full_name
    first_name.blank? ? username : "#{first_name} #{last_name}"
  end

  def ban_with_comment(comment)
    self.status_change_comment = comment
    self.banned!
  end

  def enable_with_comment(comment)
    self.status_change_comment = comment
    self.active!
  end

  def bannable
    self
  end

  def add_to_mailchimp
    MailchimpAddUserJob.perform_later(self.id)
  end

  def update_on_mailchimp
    if self.banned?
      MailchimpDeleteUserJob.perform_later(self.email)
    else
      MailchimpUpdateUserJob.perform_later(self.id, self.email_was)
    end
  end

  def delete_from_mailchimp
    MailchimpDeleteUserJob.perform_later(self.email)
  end

  def mailchimp_related_fields_updated?
    email_changed? || first_name_changed? || last_name_changed? || company_changed? || rating_changed?
  end

  def unread(convs)
    count = 0
    convs.each do |conv|
      conv.chats.each do |chat|
        # make sure I am not the sender and chat status is not read / marked / removed
        if chat.from_user_id != self.id && !chat.is_read?
          count += 1
        end
      end
    end
    count
  end

  def push_notification(msg)
    return if self.device_token.nil?
    unread_conversations = unread(conversations) + unread(user_conversations)
    badge_counter = unread_conversations # Also add other notifications to counter

    n = Rpush::Apns::Notification.new
    n.app = Rpush::Apns::App.find_by_name(Rails.application.secrets.app_name)
    n.device_token = self.device_token
    n.alert = msg
    n.data = { key: 'MSG', unread_conversations: unread_conversations }
    n.user_id = self.id
    n.badge = badge_counter
    # TODO add sent by id
    #n.sent_by_id = offered_by_id
    n.save!
  end

  def image_data(data, content_type)
    # decode data and create stream on them
    io = CarrierStringIO.new(Base64.decode64(data), content_type)

    self.profile_picture = io
  end
end

class CarrierStringIO < StringIO

  def initialize(data, content_type)
    super(data)
    @content_type = content_type
  end

  def original_filename
    "profile_picture.png"
  end

  def content_type
    @content_type
  end
end