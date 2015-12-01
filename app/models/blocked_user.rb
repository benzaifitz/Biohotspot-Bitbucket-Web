class BlockedUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :blocked_by, class_name: "User", foreign_key: "blocked_by"
end
