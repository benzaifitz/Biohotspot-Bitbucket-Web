class NotificationQueueJob < ActiveJob::Base
  queue_as :default

  def perform(attr = {})
    users = attr[:user_id].blank? ? User.where(user_type: attr[:user_type]) : User.where(id: attr[:user_id])
    users.find_each do |user|
      begin
        Notification.create!(attr.merge(user_id: user.id))
      rescue StandardError => err
        raise err
        # Todo Add exception handling
      end
    end
  end
end
