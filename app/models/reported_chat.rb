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
end
