class CreateDocumentProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :document_projects do |t|
      t.integer :project_id
      t.integer :document_id

      t.timestamps
    end
  end
end
