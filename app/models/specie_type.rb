class SpecieType < ApplicationRecord
  has_many :categories, dependent: :restrict_with_error
  validates_presence_of :name
end
