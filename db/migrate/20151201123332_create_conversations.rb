class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.string :name
      t.references :user, foreign_key: true, index: true
      t.integer :from_user_id, null: false
      t.timestamps null: false
    end
  end
end
