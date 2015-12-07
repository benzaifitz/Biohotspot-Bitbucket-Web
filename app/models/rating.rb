# == Schema Information
#
# Table name: ratings
#
#  id          :integer          not null, primary key
#  rating      :decimal(, )
#  comment     :text
#  user_id     :integer
#  rated_on_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  status      :integer          default(0), not null
#

class Rating < ActiveRecord::Base

  enum status: [:active, :reported, :censored, :allowed]
  belongs_to :user
  belongs_to :rated_on, class_name: "User", foreign_key: "rated_on_id"
  has_many :reported_ratings

end
