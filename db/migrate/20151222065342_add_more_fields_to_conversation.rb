class AddMoreFieldsToConversation < ActiveRecord::Migration
  def change
    add_column :conversations, :last_message, :text
    add_column :conversations, :last_user_id, :integer
  end
end
