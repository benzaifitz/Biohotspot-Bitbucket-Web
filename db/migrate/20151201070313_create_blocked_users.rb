class CreateBlockedUsers < ActiveRecord::Migration
  def change
    create_table :blocked_users do |t|
      t.references :user, foreign_key: true, index: true
      t.integer :blocked_by, null: false
      t.timestamps null: false
    end
  end
end
