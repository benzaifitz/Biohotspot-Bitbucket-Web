class Conversation < ActiveRecord::Base
  has_many :chats
  belongs_to :user
  belongs_to :from_user, class_name: "User", foreign_key: "from_user_id"
end
