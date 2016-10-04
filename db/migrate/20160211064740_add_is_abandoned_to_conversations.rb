class AddIsAbandonedToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :is_abandoned, :boolean, default: false
    add_index :conversations, :is_abandoned
  end
end
