class LandManager < User
  include PushNotification
  default_scope -> { where(user_type: User.user_types['land_manager']) }
  before_update :check_duplicate_email

  def check_duplicate_email
    if self.email != self.email_was && !User.find_by_email(self.email).nil?
      self.errors.add(:email, 'Duplicate email!') && false
    else
      true
    end
  end
  def self.send_push_notification_to_land_manager
    LandManager.all.each do |land_manager|
      PushNotification.sends(
          device_type: land_manager.device_type,
          device_token: land_manager.device_token,
          #badge: receiver.ios? ? Conversation.get_receivers_unread_conversation_count(receiver.id) : 0,
          data: {
              type: 'alert',
              alert: 'push notification text will be replaced here'
          }
      )
    end
  end
end