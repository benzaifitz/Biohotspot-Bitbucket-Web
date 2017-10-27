class AddProjectManagerIdToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :project_manager_id, :integer
  end
end
