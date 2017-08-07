class AddManagedProjectIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :managed_project_id, :integer, default: nil
    add_index :users, :managed_project_id
  end
end
