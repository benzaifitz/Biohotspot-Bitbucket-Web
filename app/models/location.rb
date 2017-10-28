class Location < ApplicationRecord
  belongs_to :project
  has_many :sites
  has_many :location_users
  has_many :users, :through => :location_users
  accepts_nested_attributes_for :location_users, :allow_destroy => true
  validates_presence_of :name
  validates_uniqueness_of :name, scope: :project_id

  def project_prefix_name
    "#{self.project.title rescue 'N/A'} - #{self.name}"
  end
end
