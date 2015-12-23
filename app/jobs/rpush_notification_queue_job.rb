class RpushNotificationQueueJob < ActiveJob::Base
  queue_as :rpush_notifications

  def perform(attrs = {})
    users = attrs[:user_id].blank? ? User.where(user_type: attrs[:user_type]) : User.where(id: attrs[:user_id])
    app = Rpush::Apns::App.find_by_name(Rails.application.secrets.app_name)
    users.find_each do |user|
      begin
        if attrs[:notification_type] == 'push'
          create_push_notification(attrs.merge(user: user, app: app))
        elsif attrs[:notification_type] == 'email'
          create_email_notification(attrs.merge(user: user))
        end
      rescue StandardError => err
        Rails.logger.error "[Push Notification] - #{err.message}"
      end
    end
  end

  def create_push_notification(attrs)
    n = RpushNotification.new
    n.app = attrs[:app]
    n.device_token = attrs[:user].device_token
    n.sent_by_id = attrs[:sent_by_id]
    n.user_id = attrs[:user].id
    n.user_type = attrs[:user][:user_type]
    n.alert = attrs[:alert].gsub(/<\/?[^>]*>/, "")
    n.save!
  end

  def create_email_notification(attrs)
    n = RpushNotification.new
    n.sent_by_id = attrs[:sent_by_id]
    n.user_id = attrs[:user].id
    n.user_type = attr[:user][:user_type]
    n.alert = attrs[:alert]
    n.delivered = false
    n.category = attrs[:subject]
    n.save(validate: false)
  end
end
