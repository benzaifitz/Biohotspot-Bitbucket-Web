class ProjectManagerProject < ApplicationRecord
  scope :is_admin, -> {where(is_admin: true)}
  belongs_to :project_manager
  belongs_to :project
  validates :project_manager_id, presence: true, allow_blank: false
  validates_uniqueness_of :project_manager_id, scope: :project
end
