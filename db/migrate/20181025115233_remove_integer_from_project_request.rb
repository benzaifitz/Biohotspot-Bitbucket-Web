class RemoveIntegerFromProjectRequest < ActiveRecord::Migration[5.0]
  def change
    remove_column :project_requests, :integer, :integer
  end
end
