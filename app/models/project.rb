class Project < ApplicationRecord
  has_many :users
  has_many :sites

  belongs_to :project_manager, class_name: 'User'#, foreign_key: :project_manager_id
  serialize :tags
end
