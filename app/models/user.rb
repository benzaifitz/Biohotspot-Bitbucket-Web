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
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  eula_id                :integer
#  first_name             :string
#  last_name              :string
#  company                :string
#  rating                 :decimal(, )
#  status                 :integer          default(0), not null
#  user_type              :integer          default(0), not null
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  tokens                 :json
#

class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User
  
  enum user_type: [:staff, :administrator, :customer]
  enum status: [:active, :banned]
  enum device_type: [:ios, :android]
  # manual paper trail initialization
  class_attribute :version_association_name
  self.version_association_name = :version

  # The version this instance was reified from.
  attr_accessor self.version_association_name

  belongs_to :eula
  has_many :ratings
  has_many :blocked_users
  has_many :jobs
  has_many :notifications
  has_many :chats
  has_many :conversations

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
    "#{first_name} #{last_name}"
  end

  def ban_with_comment(comment)
    self.status_change_comment = comment
    self.banned!
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

end
