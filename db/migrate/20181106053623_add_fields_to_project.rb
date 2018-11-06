class AddFieldsToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :image, :string
    add_column :projects, :ecosystem, :string
    rename_column :projects, :client_name, :organization
  end
end
