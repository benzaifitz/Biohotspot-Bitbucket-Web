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

class RpushNotification < Rpush::Client::ActiveRecord::Apns::Notification
  #belongs_to :user_type
  belongs_to :user
  #belongs_to :notification_type
  belongs_to :sender, class_name: "User", foreign_key: "sent_by_id"

  attr_accessor :user_type

end