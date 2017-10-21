class Site < ApplicationRecord
  belongs_to :project

  has_many :categories
  has_many :users

  serialize :tags
  validates_presence_of :project, :title
end
