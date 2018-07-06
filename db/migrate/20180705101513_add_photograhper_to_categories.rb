class AddPhotograhperToCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :photographer, :string
  end
end
