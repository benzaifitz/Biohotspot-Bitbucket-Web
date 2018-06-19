class Project < ApplicationRecord
  has_many :users
  has_many :locations
  has_many :document_projects
  has_many :documents, :through => :document_projects
  has_many :feedbacks
  # has_one :project_manager, class_name: 'User', foreign_key: :managed_project_id
  belongs_to :project_manager #, class_name: 'ProjectManager', foreign_key: :project_manager_id
  has_many :category_documents, through: :documents
  has_many :project_categories
  has_many :categories, :through => :project_categories
  accepts_nested_attributes_for :project_categories #, :allow_destroy => true

  validates_presence_of :project_manager_id
  serialize :tags

  # attr_accessor :project_manager_id

  # validates_presence_of :project_manager
  # accepts_nested_attributes_for :project_manager, allow_destroy: true

end
