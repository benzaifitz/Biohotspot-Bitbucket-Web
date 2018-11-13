class Project < ApplicationRecord
  attr_accessor :access_status
  mount_uploader :image, ProjectPictureUploader
  has_many :users
  has_many :locations
  has_many :document_projects
  has_many :documents, :through => :document_projects
  has_many :feedbacks
  # has_one :project_manager, class_name: 'User', foreign_key: :managed_project_id
  has_many :project_manager_projects, -> {ProjectManagerProject.where(project_manager_id: ProjectManager.all.pluck(:id))}
  has_many :project_managers, :through => :project_manager_projects #, class_name: 'ProjectManager', foreign_key: :project_manager_id
  accepts_nested_attributes_for :project_manager_projects, :project_managers, allow_destroy: true
  has_many :category_documents, through: :documents
  has_many :project_categories
  has_many :categories, :through => :project_categories
  accepts_nested_attributes_for :project_categories , :allow_destroy => true
  has_many :submissions
  has_many :project_requests
  validates :title, presence: true

  enum status: [:closed, :open]
  # validates_presence_of :project_manager_id
  serialize :tags

  before_save :check_admin_count
  before_destroy(if: lambda{|project| project.locations.any?}) { halt msg: 'Project Could not de destroyed.' }

  def check_admin_count
    pms = self.project_manager_projects.map(&:is_admin)
    if pms.index(true).nil?
      errors.add(:base, 'There should be atleast one project admin')
      return false
    end
  end

  # attr_accessor :project_manager_id

  # validates_presence_of :project_manager
  # accepts_nested_attributes_for :project_manager, allow_destroy: true
  def image_data(data, content_type)
    # decode data and create stream on them
    io = CarrierStringIO.new(Base64.decode64(data), content_type)

    self.image = io
  end

end

class CarrierStringIO < StringIO

  def initialize(data, content_type)
    super(data)
    @content_type = content_type
  end

  def original_filename
    "project_image.png"
  end

  def content_type
    @content_type
  end
end