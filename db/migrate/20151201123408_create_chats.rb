class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.text :message
      t.references :conversation, foreign_key: true, index: true
      t.references :user, foreign_key: true, index: true
      t.references :user_content_status, foreign_key: true, index: true
      t.timestamps null: false
    end
  end
end
