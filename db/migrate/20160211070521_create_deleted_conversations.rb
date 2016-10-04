class CreateDeletedConversations < ActiveRecord::Migration
  def change
    create_table :deleted_conversations do |t|
      t.references :user, foreign_key: true, index: true
      t.references :conversation, foreign_key: true, index: true

      t.timestamps null: false
    end
  end
end
