class AddConversationTypeToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :conversation_type, :integer, null: false, default: 0

    add_index :conversations, :conversation_type
  end
end
