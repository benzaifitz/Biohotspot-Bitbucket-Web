class AddApprovedProjectToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :approved, :boolean, default: false
    add_reference :users, :project, index: true
  end
end
