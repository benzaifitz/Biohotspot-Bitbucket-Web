class Submission < ApplicationRecord
  belongs_to :sub_category
  has_many :photos, as: :imageable
end
