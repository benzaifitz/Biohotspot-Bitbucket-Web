class Chat < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :user
  belongs_to :user_content_status
  has_many :reported_chats
end
