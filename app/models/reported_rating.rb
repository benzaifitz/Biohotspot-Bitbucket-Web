class ReportedRating < ActiveRecord::Base
  belongs_to :rating
  belongs_to :reported_by, class_name: "User", foreign_key: "reported_by_id"
end
