class AddStatusToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :status, :integer, index: true, default: 0, null: false
  end
end
