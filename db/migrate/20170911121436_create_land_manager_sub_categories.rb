class CreateLandManagerSubCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :land_manager_sub_categories do |t|
      t.integer :land_manager_id
      t.integer :sub_category_id

      t.timestamps
    end
  end
end
