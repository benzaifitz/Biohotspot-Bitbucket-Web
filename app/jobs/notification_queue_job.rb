class NotificationQueueJob < ApplicationJob
  queue_as :notifications

  def perform(attrs = {})
    users = attrs[:user_id].blank? ? User.where(user_type: attrs[:user_type]) : User.where(id: attrs[:user_id])
    users.find_each do |user|
      begin
        Notification.create!(attrs.merge(user_id: user.id))
      rescue StandardError => err
        raise err
        # Todo Add exception handling
      end
    end
  end
end
