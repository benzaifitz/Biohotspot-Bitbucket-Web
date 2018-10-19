class AddTokenStatusToProjectManagerProject < ActiveRecord::Migration[5.0]
  def change
    add_column :project_manager_projects, :token, :string
    add_column :project_manager_projects, :status, :integer, index: true, default: 0, null: false
  end
end
