class AddLocationToSubmission < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :location, :string
  end
end
