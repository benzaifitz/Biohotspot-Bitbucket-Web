# == Schema Information
#
# Table name: conversations
#
#  id                :integer          not null, primary key
#  user_id           :integer          not null
#  conversation_id   :integer          not null
#

class ConversationParticipant < ActiveRecord::Base
  belongs_to :community_conversation, -> { where conversation_type: Conversation.conversation_types[:community] },class_name: 'Conversation', foreign_key: 'conversation_id'
  belongs_to :participant, class_name: 'User', foreign_key: 'user_id'

  scope :for_conversation, -> (conversation_id) { where("#{ConversationParticipant.table_name}.conversation_id = ?", conversation_id)}

  validates_presence_of :conversation_id, :user_id
  validates_uniqueness_of :user_id, scope: :conversation_id

end
