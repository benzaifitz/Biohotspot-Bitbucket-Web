# == Schema Information
#
# Table name: blocked_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  blocked_by :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BlockedUser < ApplicationRecord
  belongs_to :user
  belongs_to :blocked_by, class_name: "User", foreign_key: "blocked_by_id"
  validates_presence_of :user_id, :blocked_by_id
  validates_uniqueness_of :user_id, :scope => :blocked_by_id

  after_create :cancel_associated_jobs

  def cancel_associated_jobs
    jobs = []
    if self.user.land_manager?
      jobs = Job.where(offered_by_id: self.user.id, user_id: self.blocked_by_id)
    elsif self.user.project_manager?
      jobs = Job.where(offered_by_id: self.blocked_by_id, user_id: self.user_id)
    end
    jobs.each do |j|
      j.status = 'cancelled'
      j.current_user_type = 'project_manager'
      j.save!
    end
  end
end
