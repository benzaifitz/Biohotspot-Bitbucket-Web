# == Schema Information
#
# Table name: reported_chats
#
#  id             :integer          not null, primary key
#  chat_id        :integer
#  reported_by_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class ReportedChat < ActiveRecord::Base
  belongs_to :chat
  belongs_to :reported_by, class_name: "User", foreign_key: "reported_by_id"

  delegate :ban_with_comment, :enable_with_comment, :bannable, to: :user

  validates_presence_of :chat_id, :reported_by_id
  validates_uniqueness_of :chat_id, :scope => :reported_by_id

  after_create :update_chat_status_to_reported

  def update_chat_status_to_reported
    Chat.find(self.chat_id).reported!
  end
end
