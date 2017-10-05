module PushNotification

  APNS_APP = Rpush::Apns::App.find_by_name(Rails.application.secrets.app_name)
  FCM_APP = Rpush::Gcm::App.find_by_name(Rails.application.secrets.app_name)

  def self.sends(opts)
    begin
      self.send_fcm_notifications(opts)
    rescue => exception
      Rails.logger.info "Something went wrong: #{exception}"
    end
  end

  def self.send_apns_notifications(opts)
    n = Rpush::Apns::Notification.new
    n.app = APNS_APP
    n.device_token = opts[:device_token]
    n.alert = opts[:data][:alert]
    n.user_id = opts[:data][:user_id]
    n.data = opts[:data]
    n.badge = opts[:badge] if opts[:badge].present?
    n.save!
  end

  def self.send_gcm_notifications(opts)
    n = Rpush::Gcm::Notification.new
    n.app = FCM_APP
    n.registration_ids = [opts[:device_token]]
    n.data = opts[:data]
    n.save!
  end

  def self.send_fcm_notifications(opts)
    # this is working example of FCM
    n = Rpush::Gcm::Notification.new
    n.app = FCM_APP
    n.registration_ids = [opts[:device_token]]
    n.data = {message: 'Test'}
    n.priority = 'high'
    n.user_id = opts[:user_id]
    n.content_available = true
    # n.notification = { body: 'great match!',
    #                    title: 'Portugal vs. Denmark',
    #                    icon: 'myicon'
    # }
    n.notification = opts[:notification]
    n.save!
  end

end

