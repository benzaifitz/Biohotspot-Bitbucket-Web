class AddUserAssociationsToRpushNotifications < ActiveRecord::Migration
  def change
    add_column :rpush_notifications, :user_id, :integer
    add_column :rpush_notifications, :sent_by_id, :integer
    add_index :rpush_notifications, :user_id
    add_index :rpush_notifications, :sent_by_id
  end
end
