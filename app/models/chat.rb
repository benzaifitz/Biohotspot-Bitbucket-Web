# == Schema Information
#
# Table name: chats
#
#  id              :integer          not null, primary key
#  message         :text
#  conversation_id :integer
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  status          :integer          default(0), not null
#

class Chat < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :user
  #belongs_to :user_content_status
  has_many :reported_chats
  enum status: [:unread, :read, :inappropriate, :removed]
  
  def recipient
    conversation.user
  end
  
  def sender
    user
  end
  
  def mark_read
    self.status = :read
    save
  end
  
end
