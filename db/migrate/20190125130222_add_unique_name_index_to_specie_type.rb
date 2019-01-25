class AddUniqueNameIndexToSpecieType < ActiveRecord::Migration[5.0]
  def change
  	add_index :specie_types, :name, unique: true
  end
end
