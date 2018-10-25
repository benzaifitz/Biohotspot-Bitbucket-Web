class ProjectRequest < ApplicationRecord
  belongs_to :project
  belongs_to :user
  enum status: [:accepted, :rejected, :pending]
end
