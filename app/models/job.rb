# == Schema Information
#
# Table name: jobs
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  offered_by_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  status        :integer          default(0)
#

class Job < ApplicationRecord
  include TimestampPagination

  has_paper_trail :on => [:update, :destroy]
  belongs_to :user
  belongs_to :offered_by, class_name: "User", foreign_key: "offered_by_id"
  enum status: [:offered, :completed, :accepted, :cancelled, :rejected, :withdrawn]
  attr_accessor :current_user_type

  validates_presence_of :user_id, :offered_by_id, :status, :detail
  validate :offered_by_user_is_customer, :offered_to_user_is_staff

  before_create :is_created_by_customer?
  after_create :send_push_notification_to_staff
  before_update :is_user_allowed_to_set_job_status
  after_update :send_push_notification_to_customer, :send_email_notification_to_customer, if: :status_of_customers_interest_has_changed?
  after_update :send_push_notification_to_staff, if: :status_of_staffs_interest_has_changed?

  def is_created_by_customer?
     if self.offered_by.land_manager?
       true
     else
       self.errors.add(:offered_by_id, 'Must be a land_manager!') && false
     end
  end

  def is_user_allowed_to_set_job_status
    return true if !['cancelled', 'withdrawn'].include?(status)
    if status == 'cancelled' && current_user_type == 'project_manager'
      true
    elsif status == 'withdrawn' && current_user_type == 'land_manager'
      true
    else
      self.errors.add(:status, 'Not allowed to be changed by this user type!') && false
    end
  end

  def send_push_notification_to_customer
    return if self.offered_by.nil? || self.offered_by.device_token.nil?
    n = Rpush::Apns::Notification.new
    n.app = Rpush::Apns::App.find_by_name(Rails.application.secrets.app_name)
    n.device_token = self.offered_by.device_token
    n.alert = "Status of job changed to #{status} by #{self.user.full_name}"
    n.data = { type: Job.to_s, data: { job_id: id, status: status, user_id: user_id, detail: detail, sender_thumbnail_url: self.user.profile_picture.url, sender_name: self.user.full_name} }
    n.user_id = offered_by_id
    n.sent_by_id = user_id
    n.save!
  end

  def send_email_notification_to_customer
    return if self.offered_by.nil?
    n = RpushNotification.new
    n.app = Rpush::Apns::App.find_by_name(Rails.application.secrets.app_name)
    n.category = "Job status changed to #{status}"
    n.alert = "Job Detail: #{detail} <br> Status of job changed to #{status} by #{self.user.full_name}"
    n.data = { job_id: id, status: status, user_id: user_id, detail: detail }
    n.user_id = user_id
    n.sent_by_id = offered_by_id
    n.save(validate: false)
  end

  def send_push_notification_to_staff
    return if self.user.nil? || self.user.device_token.nil?
    n = Rpush::Apns::Notification.new
    n.app = Rpush::Apns::App.find_by_name(Rails.application.secrets.app_name)
    n.device_token = self.user.device_token
    n.alert = "Status of job changed to #{status} by #{self.offered_by.full_name}"
    n.data = { type: Job.to_s, data: {job_id: id, status: status, offered_by_id: offered_by_id, detail: detail, sender_thumbnail_url: self.offered_by.profile_picture.url, sender_name: self.offered_by.full_name} }
    n.user_id = user_id
    n.sent_by_id = offered_by_id
    n.save!
  end

  def status_of_customers_interest_has_changed?
    status_changed? && (cancelled? || accepted? || rejected?)
  end

  def status_of_staffs_interest_has_changed?
    status_changed? && (offered? || withdrawn?)
  end

  def offered_by_user_is_customer
    errors.add(:offering, "user must be a land_manager." ) unless offered_by.nil? || offered_by.land_manager?
  end

  def offered_to_user_is_staff
    errors.add(:offered, "user must be project_manager." ) unless user.nil? || user.project_manager?
  end
end
