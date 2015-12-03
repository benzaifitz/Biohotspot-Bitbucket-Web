class Rating < ActiveRecord::Base
  belongs_to :user
  #belongs_to :user_content_status
  belongs_to :rated_on, class_name: "User", foreign_key: "rated_on_id"
  has_many :reported_ratings
end
