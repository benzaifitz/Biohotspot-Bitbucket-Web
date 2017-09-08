class AddLandManagerIdToSubCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :sub_categories, :user_id, :integer
    add_index :sub_categories, :user_id
  end
end
