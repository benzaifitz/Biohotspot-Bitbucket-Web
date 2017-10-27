class Location < ApplicationRecord
  belongs_to :project
  has_many :sites
  has_many :location_users
  has_many :users, :through => :location_users
  accepts_nested_attributes_for :location_users, :allow_destroy => true
  validates_presence_of :name
end
