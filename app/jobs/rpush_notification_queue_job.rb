class RpushNotificationQueueJob < ApplicationJob
  queue_as :rpush_notifications

  def perform(attrs = {})
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

  def users(attrs)
    attrs = JSON.parse(attrs)
    u = User.find(attrs['sent_by_id'])
    list = if u.project_manager? && attrs['user_id'].blank?
      u.land_managers
    elsif u.administrator? &&  attrs['user_id'].blank?
      User.where(user_type: attrs['user_type'])
    elsif u.project_manager? && !attrs['user_id'].blank?  
      if u.land_managers.map(&:id).include?(attrs['user_id'].to_i)
        User.where(id: attrs['user_id'])
      else
        []
      end  
    elsif !attrs['user_id'].blank?  
      User.where(id: attrs['user_id'])        
    end  
    # users = attrs['user_id'].blank? ? User.where(user_type: attrs['user_type']) : User.where(id: attrs['user_id'])    
  end  

  def create_push_notification(attrs)
    notification = { body: attrs['alert'],
                       title: 'Message from BioHotspot Admin',
                       icon: 'myicon'}
    opts ={device_token: attrs[:user].device_token, notification: notification,
     user_id: attrs[:user].id, sent_by_id: attrs['sent_by_id']}
    PushNotification.send_fcm_notifications(opts) if attrs[:user].device_token
  end

  def create_email_notification(attrs)
    sent_by = User.where(user_type: User.user_types[:administrator]).first
    n = RpushNotification.new
    n.app = Rpush::Apns::App.find_by_name(Rails.application.secrets.app_name)
    n.category = attrs['category']
    n.alert = attrs['alert']
    n.data = { data: { title: 'Message from BioHotspot Admin', message: attrs['alert'] } }
    n.user_id = attrs[:user].id
    n.sent_by_id = sent_by.id
    n.save(validate: false)


  end
end
