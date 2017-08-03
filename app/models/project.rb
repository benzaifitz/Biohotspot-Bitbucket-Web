class Project < ApplicationRecord
  has_many :users
  has_many :sites

  serialize :tags
end
