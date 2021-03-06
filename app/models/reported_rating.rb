# == Schema Information
#
# Table name: reported_ratings
#
#  id             :integer          not null, primary key
#  rating_id      :integer
#  reported_by_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class ReportedRating < ApplicationRecord
  belongs_to :rating
  belongs_to :reported_by, class_name: "User", foreign_key: "reported_by_id"

  delegate :ban_with_comment, :enable_with_comment, :bannable, to: :rating

  validates_presence_of :rating_id, :reported_by_id
  validates_uniqueness_of :rating_id, :scope => :reported_by_id

  after_create :update_rating_status_to_reported

  def update_rating_status_to_reported
    Rating.find(self.rating_id).reported!
  end


end
