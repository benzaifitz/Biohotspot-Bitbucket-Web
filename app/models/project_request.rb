class ProjectRequest < ApplicationRecord
  belongs_to :project
  belongs_to :user
  enum status: [:accepted, :rejected, :pending]
  after_create :notify_project_managers

  def notify_project_managers
    NotificationMailer.notify_project_managers(self).deliver
  end
end
