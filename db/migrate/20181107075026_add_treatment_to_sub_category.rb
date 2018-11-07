class AddTreatmentToSubCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :sub_categories, :treatment, :string
  end
end
