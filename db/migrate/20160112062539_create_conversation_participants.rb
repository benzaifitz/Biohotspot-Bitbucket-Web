
class CreateConversationParticipants < ActiveRecord::Migration
  def change
    create_table :conversation_participants do |t|
      t.integer :conversation_id, null: false, index: true
      t.integer :user_id, null: false, index: true

      t.timestamps null: false
    end
  end
end
