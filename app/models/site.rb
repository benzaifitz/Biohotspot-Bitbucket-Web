class Site < ApplicationRecord
  belongs_to :project

  has_many :categories

  serialize :tags
  validates_presence_of :project, :title
end
