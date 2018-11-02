class SubCategory < ApplicationRecord
  # belongs_to :category
  has_many :category_sub_categories, dependent: :destroy
  has_many :categories, :through => :category_sub_categories
  belongs_to :site
  accepts_nested_attributes_for :category_sub_categories#, :allow_destroy => true

  # belongs_to :user
  has_many :land_manager_sub_categories
  has_many :land_managers, :through => :land_manager_sub_categories
  accepts_nested_attributes_for :land_manager_sub_categories#, :allow_destroy => true
  has_one :submission
  # validates_presence_of :category_id #, :user_id
  validates_uniqueness_of :name, scope: :site_id
  validates :site, presence: true

  UNKNOWN_SAMPLE = 'New Sample'

  def current_user_submission(current_user_id)
    Submission.where(submitted_by: current_user_id, sub_category_id: self.id).first
  end

  def project_location_site_prefix_name
    "#{self.site.location.project.title rescue 'N/A'} - #{self.site.location.name rescue 'N/A'} - #{self.site.title rescue 'N/A'} - #{self.name}"
  end

  def site_title
    self.site.title rescue 'UNKNOWN'
  end

end
