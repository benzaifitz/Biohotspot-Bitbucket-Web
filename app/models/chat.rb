# == Schema Information
#
# Table name: chats
#
#  id              :integer          not null, primary key
#  message         :text
#  conversation_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  status          :integer          default(0), not null
#  from_user_id    :integer

class Chat < ActiveRecord::Base
  include TimestampPagination
  belongs_to :conversation
  belongs_to :from_user, class_name: "User", foreign_key: "from_user_id"
  has_many :reported_chats, dependent: :destroy
  enum status: [:active, :reported, :censored, :allowed]

  validates_presence_of :from_user_id, :conversation_id, :status
  validate :conversation_is_not_abandoned

  delegate :ban_with_comment, :enable_with_comment, :bannable, to: :from_user
  delegate :recipient, to: :conversation

  def sender
    from_user
  end
  
  def mark_read
    self.is_read = true
    save
  end

  def conversation_is_not_abandoned
    if self.conversation && self.conversation.is_abandoned
      self.errors.add(:message, 'could not be sent as this conversation was abandoned.')
    end
  end
  
end
