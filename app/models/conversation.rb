# == Schema Information
#
# Table name: conversations
#
#  id                :integer          not null, primary key
#  name              :string
#  user_id           :integer
#  from_user_id      :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  last_message      :text
#  last_user_id      :integer
#  conversation_type :integer          not null, default 0
#  topic             :string
#

class Conversation < ActiveRecord::Base
  include TimestampPagination
  has_many :chats
  has_many :conversation_participants
  belongs_to :from_user, class_name: "User", foreign_key: "from_user_id"
  belongs_to :recipient, class_name: "User", foreign_key: "user_id"
  has_many :participants, through: :conversation_participants

  enum conversation_type: [:direct, :community]

  scope :private_conversations_of_user, -> (user_id){ where('from_user_id = ? OR user_id = ? AND conversation_type = ?', user_id, user_id, conversation_types[:direct])}

  validates_presence_of :from_user_id
  validates_presence_of :user_id, if: "direct?"
  validate :users_do_not_have_chat, if: "user_id.present? && from_user_id.present? && direct?"

  def add_participants(user_ids)
    self.errors.add(:base, 'Cannot add participants to a private chat.') and return unless community?
    user_ids.split(',').each do |user_id|
      conversation = ConversationParticipant.new(conversation_id: self.id, user_id: user_id)
      unless conversation.save
        self.errors.add(:base, 'An error occured while adding one or more participants.')
      end
    end
  end

  def has_participant?(user_id)
    Conversation.get_all_chats_for_user(user_id).exists?
  end

  def self.get_all_chats_for_user(user_id)
    Conversation.joins("LEFT JOIN #{ConversationParticipant.table_name} ON #{ConversationParticipant.table_name}.conversation_id = #{Conversation.table_name}.id")
            .where("(#{Conversation.table_name}.user_id = ? OR #{Conversation.table_name}.from_user_id = ? AND conversation_type = ?)
            OR (#{ConversationParticipant.table_name}.user_id = ? AND conversation_type = ?)",
            user_id, user_id, conversation_types[:direct], user_id, conversation_types[:community])
  end

  private

  def users_do_not_have_chat
    combinations = ["user_id = #{self.user_id} AND from_user_id = #{self.from_user_id}",
                    "from_user_id = #{self.user_id} AND user_id = #{self.from_user_id}"]
    if Conversation.where(combinations.join(' OR ')).exists?
      self.errors.add(:user_id, 'Chat already exists!')
    end
  end
end
