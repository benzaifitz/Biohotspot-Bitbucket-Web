class Site < ApplicationRecord
  # belongs_to :project
  belongs_to :location
  has_many :categories
  has_many :users

  serialize :tags
  validates_presence_of :location, :title
end
