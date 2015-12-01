class CreateReportedChats < ActiveRecord::Migration
  def change
    create_table :reported_chats do |t|
      t.references :chat, index: true, foreign_key: true
      t.integer :reported_by_id, null: false
      t.timestamps null: false
    end
  end
end
