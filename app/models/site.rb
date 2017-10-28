class Site < ApplicationRecord
  # belongs_to :project
  belongs_to :location
  has_many :categories
  has_many :sub_categories
  # has_many :site_categories
  # has_many :categories, :through => :site_categories
  # accepts_nested_attributes_for :site_categories, :allow_destroy => true
  has_many :users

  serialize :tags
  validates_presence_of :location, :title
  validates_uniqueness_of :title, scope: :location_id


  def project_location_prefix_name
    "#{self.location.project.title rescue 'N/A'} - #{self.location.name rescue 'N/A'} - #{self.title}"
  end
end
