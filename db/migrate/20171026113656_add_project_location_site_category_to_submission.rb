class AddProjectLocationSiteCategoryToSubmission < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :project_id, :integer
    add_column :submissions, :location_id, :integer
    add_column :submissions, :site_id, :integer
    add_column :submissions, :category_id, :integer
  end
end
