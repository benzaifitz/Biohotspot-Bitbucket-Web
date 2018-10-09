class AddIsAdminToProjectManagerProject < ActiveRecord::Migration[5.0]
  def change
    add_column :project_manager_projects, :is_admin, :boolean, default: false
  end
end
