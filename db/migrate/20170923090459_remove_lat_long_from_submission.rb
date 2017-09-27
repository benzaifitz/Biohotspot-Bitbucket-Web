class RemoveLatLongFromSubmission < ActiveRecord::Migration[5.0]
  def change
    remove_column :submissions, :lat
    remove_column :submissions, :long
    remove_column :submissions, :location
  end
end
