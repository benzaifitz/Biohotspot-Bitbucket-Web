class AddSiteToSubCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :sub_categories, :site_id, :integer
  end
end
