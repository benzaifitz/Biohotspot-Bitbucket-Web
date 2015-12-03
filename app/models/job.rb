class Job < ActiveRecord::Base
  belongs_to :user
  #belongs_to :job_status
  belongs_to :owner, class_name: "User", foreign_key: "offered_by"
end
