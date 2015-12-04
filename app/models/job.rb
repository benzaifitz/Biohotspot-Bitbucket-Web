# == Schema Information
#
# Table name: jobs
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  offered_by :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :integer          default(0)
#

class Job < ActiveRecord::Base
  belongs_to :user
  #belongs_to :job_status
  belongs_to :owner, class_name: "User", foreign_key: "offered_by"
end
