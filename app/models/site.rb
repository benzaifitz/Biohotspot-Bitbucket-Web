class Site < ApplicationRecord
  belongs_to :project

  serialize :tags
  validates_presence_of :project, :title
end
