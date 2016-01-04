class AddIsReadToChats < ActiveRecord::Migration
  def change
    add_column :chats, :is_read, :boolean, default: false
  end
end
