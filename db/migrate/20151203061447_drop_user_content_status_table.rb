class DropUserContentStatusTable < ActiveRecord::Migration
  def change
    remove_column :ratings, :user_content_status_id
    remove_column :chats, :user_content_status_id
    add_column :ratings, :status, :integer, default: 0, null: false
    add_column :chats, :status, :integer, default: 0, null: false
    drop_table :user_content_statuses
  end
end