class DropUserStatusesTable < ActiveRecord::Migration
  def change
    remove_column :users, :user_status_id
    add_column :users, :status, :integer, default: 0, null: false
    drop_table :user_statuses
  end
end
