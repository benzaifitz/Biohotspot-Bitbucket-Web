class AddProjectManagerIdToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :project_manager_id, :integer, default: nil
    add_index :projects, :project_manager_id
  end
end
