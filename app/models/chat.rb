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
#  from_user_id    :integer

class Chat < ActiveRecord::Base
  include TimestampPagination
  belongs_to :conversation
  belongs_to :user
  belongs_to :from_user, class_name: "User", foreign_key: "from_user_id"
  has_many :reported_chats
  enum status: [:active, :reported, :censored, :allowed]
  delegate :ban_with_comment, :enable_with_comment, :bannable, to: :user
  
  def recipient
    from_user
  end

  def sender
    user
  end
  
  def mark_read
    self.is_read = true
    save
  end
  
end
