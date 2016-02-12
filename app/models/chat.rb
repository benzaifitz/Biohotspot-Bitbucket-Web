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

  after_create :send_push_notification_to_reciever, :send_email_notification_to_customer

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

  def send_push_notification_to_reciever
    conversation = self.conversation
    sender, receiver = get_users_for_chat(conversation)

    return if receiver.device_token.nil? || receiver.is_logged_out?
    n = Rpush::Apns::Notification.new
    n.app = Rpush::Apns::App.find_by_name(Rails.application.secrets.app_name)
    n.device_token = receiver.device_token
    n.alert = "#{sender.full_name} sent you a message: #{self.message}"
    n.data = { type: Chat.to_s, conversation_id: self.conversation_id, message_id: self.id, message: self.message }
    n.user_id = receiver.id
    n.sent_by_id = sender.id
    n.save!
  end

  def send_email_notification_to_customer
    conversation = self.conversation
    sender, receiver = get_users_for_chat(conversation)
    return unless receiver.is_logged_out?

    n = RpushNotification.new
    n.app = Rpush::Apns::App.find_by_name(Rails.application.secrets.app_name)
    n.category = "#{sender.full_name} sent you a message"
    n.alert = "#{sender.full_name} sent you a message: #{self.message}"
    n.data = { type: Chat.to_s, conversation_id: self.conversation_id, message_id: self.id, message: self.message }
    n.user_id = receiver.id
    n.sent_by_id = sender.id
    n.save(validate: false)
  end

  def get_users_for_chat(conversation)
    if self.from_user_id == conversation.from_user_id
      receiver = conversation.recipient
      sender = conversation.from_user
    else
      receiver = conversation.from_user
      sender = conversation.recipient
    end
    [sender, receiver]
  end
end
