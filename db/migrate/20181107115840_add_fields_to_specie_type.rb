class AddFieldsToSpecieType < ActiveRecord::Migration[5.0]
  def change
    add_column :specie_types, :phylum, :string
    add_column :specie_types, :klass, :string
    add_column :specie_types, :order, :string
    add_column :specie_types, :superfamily, :string
    add_column :specie_types, :family, :string
    add_column :specie_types, :genus, :string
    add_column :specie_types, :species, :string
    add_column :specie_types, :sub_species, :string
  end
end
