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

class ReportedRating < ActiveRecord::Base
  belongs_to :rating
  belongs_to :reported_by, class_name: "User", foreign_key: "reported_by_id"
end
