class AddFromUserToChat < ActiveRecord::Migration
  def change
    add_column :chats, :from_user_id, :integer, null: false, default: 0
  end
end
