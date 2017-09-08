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
#  mobile_number          :string          default(0)

class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  mount_uploader :profile_picture, ProfilePictureUploader
  enum user_type: [:project_manager, :administrator, :land_manager]
  enum status: [:active, :banned]
  enum device_type: {:ios => "0", :android => "1"}
  # manual paper trail initialization
  class_attribute :version_association_name
  self.version_association_name = :version

  # The version this instance was reified from.
  attr_accessor self.version_association_name

  belongs_to :eula
  belongs_to :privacy
  belongs_to :project
  has_many :ratings, dependent: :destroy
  has_many :rated_on_ratings, class_name: 'Rating', foreign_key: 'rated_on_id', dependent: :destroy
  has_many :blocked_users, dependent: :destroy
  has_many :blocked_by_blocked_users, class_name: 'BlockedUser', foreign_key: 'blocked_by_id', dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :offered_by_jobs, class_name: 'Job', foreign_key: 'offered_by_id', dependent: :destroy
  has_many :chats, foreign_key: 'from_user_id', dependent: :destroy
  has_many :user_conversations, class_name: 'Conversation', foreign_key: "from_user_id", dependent: :destroy
  has_many :recipient_conversations, ->{ where conversation_type: Conversation.conversation_types[:direct]}, class_name: 'Conversation', foreign_key: 'user_id', dependent: :destroy
  has_many :conversation_participants, dependent: :destroy
  has_many :community_conversations, through: :conversation_participants, foreign_key: 'user_id'
  has_many :rpush_notifications, dependent: :destroy
  has_many :sub_categories, dependent: :destroy

  validates_presence_of :email
  # validates_presence_of :company, if: Proc.new { |user| user.project_manager? }
  validates_presence_of :project_id, if: Proc.new { |user| user.land_manager? }
  validates_presence_of :mobile_number, if: lambda { |user| user.land_manager? }
  validates_uniqueness_of :email

  attr_accessor :status_change_comment, :mailchimp_fields_updated, :status_updated

  after_update :log_user_events
  #after_commit :add_to_mailchimp, on: :create
  after_update do
    #self.mailchimp_fields_updated = mailchimp_related_fields_updated?
    self.status_updated = status_changed?
  end
  #after_commit :update_on_mailchimp, if: 'self.mailchimp_fields_updated || self.status_updated', on: :update
  #after_commit :delete_from_mailchimp, on: :destroy

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
    (first_name.blank? && last_name.blank?) ? username : "#{first_name} #{last_name}"
  end

  def ban_with_comment(comment)
    self.status_change_comment = comment
    self.banned!
  end

  def approve_with_comment(comment)
    self.status_change_comment = comment
    update_attributes!(approved: !approved)
  end

  def reject_with_comment(comment)
    self.status_change_comment = comment
    update_attributes!(approved: !approved)
  end

  def disable_with_comment(comment)
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

  def is_logged_out?
    self.current_sign_in_at.nil? || (self.current_sign_in_at + DeviseTokenAuth.token_lifespan.to_i) < Time.now
  end

  def push_notification(msg)
    return if self.device_token.nil?
    unread_conversations = unread(conversations) + unread(user_conversations)
    badge_counter = unread_conversations # Also add other notifications to counter

    n = Rpush::Apns::Notification.new
    n.app = Rpush::Apns::App.find_by_name(Rails.application.secrets.app_name)
    n.device_token = self.device_token
    n.alert = msgst
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