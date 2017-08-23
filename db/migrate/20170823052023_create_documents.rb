class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|

      t.string :document
      t.string :name
      t.references :project, index:true
      t.references :category_document, index:true
      t.timestamps
    end
  end
end
