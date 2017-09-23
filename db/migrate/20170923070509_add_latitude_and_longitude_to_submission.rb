class AddLatitudeAndLongitudeToSubmission < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :latitude, :float
    add_column :submissions, :longitude, :float
  end
end
