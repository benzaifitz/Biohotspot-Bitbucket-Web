class CategoryDocument < ApplicationRecord
  has_many :documents
  validates_presence_of :name
end
