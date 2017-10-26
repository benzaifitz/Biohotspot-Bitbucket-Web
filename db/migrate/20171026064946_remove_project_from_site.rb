class RemoveProjectFromSite < ActiveRecord::Migration[5.0]
  def up
    remove_column :sites, :project_id, :integer
  end

  def down
    add_column :sites, :project_id, :integer
  end
end
