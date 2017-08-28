class CreateCategoryDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :category_documents do |t|

      t.string :name
      t.timestamps
    end
  end
end
