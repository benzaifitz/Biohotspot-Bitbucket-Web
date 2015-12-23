# == Schema Information
#
# Table name: jobs
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  offered_by_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  status        :integer          default(0)
#

class Job < ActiveRecord::Base
  has_paper_trail :on => [:update, :destroy]
  belongs_to :user
  belongs_to :offered_by, class_name: "User", foreign_key: "offered_by_id"
  enum status: [:offered, :completed, :accepted, :cancelled, :rejected, :withdrawn]
end
