# == Schema Information
#
# Table name: jobs
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  offered_by_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :integer          default(0)
#

class Job < ActiveRecord::Base
  has_paper_trail :on => [:update, :destroy]
  belongs_to :user
  belongs_to :offered_by, class_name: "User", foreign_key: "offered_by_id"
  enum status: [:offered, :completed, :accepted, :cancelled, :rejected, :withdrawn]
  attr_accessor :current_user_type

  validates_presence_of :user_id, :offered_by_id, :status, :description

  before_update :is_user_allowed_to_set_job_status
  after_update :send_push_notification_to_customer, if: :status_of_customers_interest_has_changed?
  after_update :send_push_notification_to_staff, if: :status_of_staffs_interest_has_changed?

  def is_user_allowed_to_set_job_status
    return true if !['cancelled', 'withdrawn'].include?(status)
    if status == 'cancelled' && current_user_type == 'staff'
      true
    elsif status == 'withdrawn' && current_user_type == 'customer'
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
    n.data = { job_id: id, status: status, user_id: user_id, description: description }
    n.save!
  end

  def send_push_notification_to_staff
    return if self.user.nil? || self.user.device_token.nil?
    n = Rpush::Apns::Notification.new
    n.app = Rpush::Apns::App.find_by_name(Rails.application.secrets.app_name)
    n.device_token = self.user.device_token
    n.alert = "Status of job changed to #{status} by #{self.offered_by.full_name}"
    n.data = { job_id: id, status: status, offered_by_id: offered_by_id, description: description }
    n.save!
  end

  def status_of_customers_interest_has_changed?
    status_changed? && (cancelled? || accepted? || rejected?)
  end

  def status_of_staffs_interest_has_changed?
    status_changed? && (offered? || withdrawn?)
  end

end
