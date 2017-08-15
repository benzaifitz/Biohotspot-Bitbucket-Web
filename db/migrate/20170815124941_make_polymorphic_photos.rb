class MakePolymorphicPhotos < ActiveRecord::Migration[5.0]
  def change
    remove_index :photos, :category_id
    remove_column :photos, :category_id
    add_column :photos, :imageable_id, :integer
    add_column :photos, :imageable_type, :string
    add_index :photos, [:imageable_id, :imageable_type]
  end
end
