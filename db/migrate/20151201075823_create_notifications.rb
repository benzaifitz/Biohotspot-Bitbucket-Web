class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :subject
      t.text :message
      t.references :user_type, foreign_key: true, index: true
      t.references :user, foreign_key: true, index: true
      t.references :notification_type, index: true
      t.integer :sent_by_id, null: false
      t.timestamps null: false
    end
  end
end
