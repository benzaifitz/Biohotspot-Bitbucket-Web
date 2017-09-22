class LandManager < User

  has_many :feedbacks
  has_many :land_manager_sub_categories
  has_many :sub_categories, :through => :land_manager_sub_categories
  accepts_nested_attributes_for :land_manager_sub_categories, :allow_destroy => true

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
          data: {
              type: 'alert',
              alert: 'Your weed survey is due. Please notify us in the feedback form if you are unable to complete. Have a great day.'
          }
      )
    end
  end

  def send_photo_rejected_pn(message = '')
      PushNotification.sends(
          device_type: self.device_type,
          device_token: self.device_token,
          data: {
              type: 'alert',
              alert: message
          }
      )
  end
end