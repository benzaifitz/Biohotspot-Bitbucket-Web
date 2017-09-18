class Feedback < ApplicationRecord
  belongs_to :project
  belongs_to :land_manager, class_name: 'LandManager', foreign_key: 'land_manager_id'

  after_create :email_admin, :email_project_manager

  def email_admin

  end

  def email_project_manager

  end
end
