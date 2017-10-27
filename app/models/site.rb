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
end
