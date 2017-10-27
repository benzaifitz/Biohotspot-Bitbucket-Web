class CreateProjectManagerProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :project_manager_projects do |t|
      t.integer :project_id
      t.integer :project_manager_id

      t.timestamps
    end
  end
end
