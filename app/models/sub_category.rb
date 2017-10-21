class SubCategory < ApplicationRecord
  belongs_to :category
  # belongs_to :user
  has_many :land_manager_sub_categories
  has_many :land_managers, :through => :land_manager_sub_categories
  accepts_nested_attributes_for :land_manager_sub_categories, :allow_destroy => true
  has_one :submission
  validates_presence_of :category_id #, :user_id

  def current_user_submission(current_user_id)
    Submission.where(submitted_by: current_user_id, sub_category_id: self.id).first
  end
end
