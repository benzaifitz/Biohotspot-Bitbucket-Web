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
  has_many :chats
  belongs_to :user
  belongs_to :from_user, class_name: "User", foreign_key: "from_user_id"
  validates_uniqueness_of :user_id, :scope => :from_user_id
end
