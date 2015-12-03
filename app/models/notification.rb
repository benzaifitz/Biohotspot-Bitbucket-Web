class Notification < ActiveRecord::Base
  #belongs_to :user_type
  belongs_to :user
  #belongs_to :notification_type
  belongs_to :sender, class_name: "User", foreign_key: "sent_by_id"
end
