class AddDeletedToRpushNotification < ActiveRecord::Migration[5.0]
  def self.up
    add_column :rpush_notifications, :deleted, :boolean, default: false
  end

  def self.down
    remove_column :rpush_notifications, :deleted
  end
end
