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

  before_update :is_user_allowed_to_set_job_status
  after_update :send_push_notification_to_customer, if: Proc.new {|job| job.status_changed? &&
                                                 (job.cancelled? || job.accepted? || job.rejected?)}
  after_update :send_push_notification_to_staff

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

  end

  def send_push_notification_to_staff

  end

end
