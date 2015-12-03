class DropNotificationTypesTable < ActiveRecord::Migration
  def change
    remove_column :notifications, :notification_type_id
    add_column :notifications, :notification_type, :integer, default: 0, null: false
    drop_table :notification_types
  end
end