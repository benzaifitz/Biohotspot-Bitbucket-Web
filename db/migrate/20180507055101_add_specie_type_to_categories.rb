class AddSpecieTypeToCategories < ActiveRecord::Migration[5.0]
  def change
    add_reference :categories, :specie_type, foreign_key: true, index: true
  end
end
