class Project < ApplicationRecord
  has_many :users

  serialize :tags
end
