class AddIsAdminNotificationToRpushNotifications < ActiveRecord::Migration
  def change
    add_column :rpush_notifications, :is_admin_notification, :boolean, default: false
    add_index :rpush_notifications, :is_admin_notification
  end
end
