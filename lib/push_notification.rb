module PushNotification

  APNS_APP = Rpush::Apns2::App.find_by_name(Rails.application.secrets.app_name)
  FCM_APP = Rpush::Gcm::App.find_by_name(Rails.application.secrets.app_name)

  def self.sends(opts)
    begin
      case opts[:device_type]
        when "ios"
          self.send_apns_notifications(opts)
        when "android"
          self.send_gcm_notifications(opts)
      end
    rescue => exception
      Rails.logger.info "Something went wrong: #{exception}"
    end
  end

  def self.send_apns_notifications(opts)
    n = Rpush::Apns2::Notification.new
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

end