class AddDescriptionToLocation < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :description, :text
  end
end
