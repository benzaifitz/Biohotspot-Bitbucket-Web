class DropBlockedUsers < ActiveRecord::Migration
  def change
    drop_table :blocked_users
  end
end
