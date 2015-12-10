class BulkNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(sender_id, user_group_type, message, subject, notification_type)
    User.send(user_group_type).find_each do |user|
      begin
        Notification.save(user.id, user[:user_type], message, subject, notification_type, Notification.statuses[:created], sender_id)
      rescue StandardError => err
        # Todo Add exception handling
      end
    end
  end
end
