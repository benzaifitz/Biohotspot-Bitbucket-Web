class AddLocationToSite < ActiveRecord::Migration[5.0]
  def change
    add_column :sites, :location_id, :integer
  end
end
