class AddSubTypeToPhoto < ActiveRecord::Migration[5.0]
  def change
    add_column :photos, :imageable_sub_type, :string
  end
end
