class AddPmInvitedToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :pm_invited, :boolean, default: false
  end
end
