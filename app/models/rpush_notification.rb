# == Schema Information
#
# Table name: rpush_notifications
#
# integer    "badge"
# string   "device_token",      limit: 64
# string   "sound",                        default: "default"
# string   "alert"
# text     "data"
# integer  "expiry",                       default: 86400
# boolean  "delivered",                    default: false,     null: false
# datetime "delivered_at"
# boolean  "failed",                       default: false,     null: false
# datetime "failed_at"
# integer  "error_code"
# text     "error_description"
# datetime "deliver_after"
# datetime "created_at"
# datetime "updated_at"
# boolean  "alert_is_json",                default: false
# string   "type",                                             null: false
# string   "collapse_key"
# boolean  "delay_while_idle",             default: false,     null: false
# text     "registration_ids"
# integer  "app_id",                                           null: false
# integer  "retries",                      default: 0
# string   "uri"
# datetime "fail_after"
# boolean  "processing",                   default: false,     null: false
# integer  "priority"
# text     "url_args"
# string   "category"
# integer  "user_id"
# integer  "sent_by_id"

class Rpush::Client::ActiveRecord::Notification
  include TimestampPagination

  belongs_to :user
  belongs_to :sender, class_name: "User", foreign_key: "sent_by_id"
end

class RpushNotification < Rpush::Client::ActiveRecord::Apns::Notification
  attr_accessor :user_type
  attr_accessor :notification_type

  after_commit :enqueue_email_for_sending, on: :create

  NOTIFICATION_TYPE = { email: 'email', push: 'push'}


  class << self
    def enqueue_email_and_mark_it_sent(notification_id)
      notification = RpushNotification.find(notification_id)
      begin
        NotificationMailer.notification_email(notification).deliver_now
        notification.delivered = true
        notification.delivered_at = Time.now
        notification.save(validate: false)
      rescue StandardError => e
        notification.failed = true
        notification.failed_at = Time.now
        notification.save(validate: false)
      end
    end
  end

  def notification_type
    self.device_token.nil? ? NOTIFICATION_TYPE[:email].capitalize : NOTIFICATION_TYPE[:push].capitalize
  end

  protected

  def enqueue_email_for_sending
    if self.device_token.nil?
      RpushNotification.delay.enqueue_email_and_mark_it_sent(self.id)
    end
  end
end


