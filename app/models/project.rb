class Project < ApplicationRecord
  has_many :users
  has_many :sites
  has_many :document_projects
  has_many :documents, :through => :document_projects
  has_many :feedbacks

  has_one :project_manager, class_name: 'User', foreign_key: :managed_project_id
  # belongs_to :project_manager, class_name: 'User'#, foreign_key: :project_manager_id
  serialize :tags

  attr_accessor :project_manager_id

  # validates_presence_of :project_manager
  accepts_nested_attributes_for :project_manager, allow_destroy: true

end
