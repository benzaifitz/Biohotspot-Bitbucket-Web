class AddFieldsToCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :family_scientific, :string
    add_column :categories, :species_scientific, :string
    add_column :categories, :species_common, :string
    add_column :categories, :status, :string
    add_column :categories, :growth, :string
    add_column :categories, :habit, :string
    add_column :categories, :impact, :string
    add_column :categories, :distribution, :string

    rename_column :categories, :family, :family_common
  end
end
