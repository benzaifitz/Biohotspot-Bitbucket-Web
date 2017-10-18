class RpushNotificationQueueJob < ApplicationJob
  queue_as :rpush_notifications

  def perform(attrs = {})
    attrs = JSON.parse(attrs)
    users = attrs[:user_id].blank? ? User.where(user_type: attrs['user_type']).where.not(device_token: nil) : User.where(id: attrs['user_id']).where.not(device_token: nil)
    users.find_each do |user|
      begin
        if attrs['notification_type'] == RpushNotification::NOTIFICATION_TYPE[:push]
          create_push_notification(attrs.merge(user: user))
        elsif attrs['notification_type'] == RpushNotification::NOTIFICATION_TYPE[:email]
          create_email_notification(attrs.merge(user: user))
        end
      rescue StandardError => err
        Rails.logger.error "[Push Notification] - #{err.message}"
      end
    end
  end

  def create_push_notification(attrs)
    notification = { body: attrs['alert'],
                       title: 'Message from PWM Admin',
                       icon: 'myicon'}
    opts ={device_token: attrs[:user].device_token, notification: notification,
     user_id: attrs[:user].id, sent_by_id: attrs['sent_by_id']}
    PushNotification.send_fcm_notifications(opts)
  end

  def create_email_notification(attrs)
    n = RpushNotification.new
    n.sent_by_id = attrs[:sent_by_id]
    n.user_id = attrs[:user].id
    n.app = attrs[:app]
    n.user_type = attrs[:user][:user_type]
    n.alert = attrs[:alert]
    n.delivered = false
    n.category = attrs[:category]
    n.is_admin_notification = true
    n.save(validate: false)
  end
end
