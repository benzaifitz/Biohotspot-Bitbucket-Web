class Location < ApplicationRecord
  belongs_to :project
  has_many :sites
  validates_presence_of :name
end
