class Feedback < ApplicationRecord
  belongs_to :project
  belongs_to :land_manager, class_name: 'LandManager', foreign_key: 'land_manager_id'

  after_commit :email_admin, :email_project_manager

  def email_admin
    FeedbackMailer.email_admin(self.id).deliver_now
  end

  def email_project_manager
    FeedbackMailer.email_project_manager(self.id).deliver_now
  end
end
