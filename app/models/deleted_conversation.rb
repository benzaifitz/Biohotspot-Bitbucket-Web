# == Schema Information
#
# Table name: conversations
#
#  id                :integer          not null, primary key
#  user_id           :integer          not null
#  conversation_id   :integer          not null
#

class DeletedConversation < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  scope :for_conversation, -> (conversation_id) { where("#{ConversationParticipant.table_name}.conversation_id = ?", conversation_id)}

  validates_presence_of :conversation_id, :user_id
  validates_uniqueness_of :conversation_id, scope: :user_id, message: 'This conversation has already been deleted by you.'

  after_create :mark_conversation_as_abandoned

  def mark_conversation_as_abandoned
    self.conversation.update_attribute(:is_abandoned, true)
  end
end
