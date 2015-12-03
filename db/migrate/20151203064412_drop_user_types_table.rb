class DropUserTypesTable < ActiveRecord::Migration
  def change
    remove_column :users, :user_type_id
    remove_column :notifications, :user_type_id
    add_column :users, :user_type, :integer, default: 0, null: false
    add_column :notifications, :user_type, :integer, default: 0, null: false
    drop_table :user_types
  end
end
