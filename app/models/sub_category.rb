class SubCategory < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :submissions
  validates_presence_of :category_id, :user_id
end
