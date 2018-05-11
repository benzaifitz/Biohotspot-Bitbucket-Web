class SpecieType < ApplicationRecord
  has_many :categories, dependent: :restrict_with_error
end
