class SubCategory < ApplicationRecord
  belongs_to :category
  # belongs_to :user
  has_many :land_manager_sub_categories
  has_many :land_managers, :through => :land_manager_sub_categories
  accepts_nested_attributes_for :land_manager_sub_categories, :allow_destroy => true
  has_one :submission
  scope :current_user_submission, -> (current_user_id){ Submission.where('submitted_by = ?', current_user_id).first }
  validates_presence_of :category_id #, :user_id
end
