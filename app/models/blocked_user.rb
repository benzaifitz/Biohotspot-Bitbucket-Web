# == Schema Information
#
# Table name: blocked_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  blocked_by :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BlockedUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :blocked_by, class_name: "User", foreign_key: "blocked_by_id"
end
