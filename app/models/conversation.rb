# == Schema Information
#
# Table name: conversations
#
#  id           :integer          not null, primary key
#  name         :string
#  user_id      :integer
#  from_user_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  last_message :text
#  last_user_id :integer
#

class Conversation < ActiveRecord::Base
  include TimestampPagination
  has_many :chats
  belongs_to :user
  belongs_to :from_user, class_name: "User", foreign_key: "from_user_id"

  validates_presence_of :user_id, :from_user_id
  validate :users_do_not_have_chat, if: "user_id.present? && from_user_id.present?"

  def users_do_not_have_chat
    combinations = ["user_id = #{self.user_id} AND from_user_id = #{self.from_user_id}",
                    "from_user_id = #{self.user_id} AND user_id = #{self.from_user_id}"]
    if Conversation.where(combinations.join(' OR ')).exists?
      self.errors.add(:user_id, 'Chat already exists!')
    end
  end
end
