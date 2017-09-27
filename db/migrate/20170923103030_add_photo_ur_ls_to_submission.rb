class AddPhotoUrLsToSubmission < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :sample_photo_full_url, :string
    add_column :submissions, :monitoring_photo_full_url, :string
  end
end
