class NotificationQueueJob < ActiveJob::Base
  queue_as :default

  def perform(attr = {})
    users = attr[:user_id].nil? ? User.where(user_type: attr[:user_type]) : User.where(id: attr[:user_id])
    users.find_each do |user|
      begin
        Notification.create!(attr.merge(user_id: user.id))
        # , user_type: user[:user_type], message: message, subject: subject,
        #   notification_type: notification_type, status: Notification.statuses[:created], sent_by_id: sender_id)
      rescue StandardError => err
        # Todo Add exception handling
      end
    end
  end
end
