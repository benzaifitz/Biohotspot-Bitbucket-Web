class RemoveUsernameConstraintsToUsers < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :username, :string, :null => true
    remove_index(:users, :name => 'index_users_on_username')
  end
end
