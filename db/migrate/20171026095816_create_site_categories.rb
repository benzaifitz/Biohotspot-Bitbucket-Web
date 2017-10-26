class CreateSiteCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :site_categories do |t|
      t.integer :site_id
      t.integer :category_id

      t.timestamps
    end
  end
end
