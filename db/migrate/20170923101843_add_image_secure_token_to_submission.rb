class AddImageSecureTokenToSubmission < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :monitoring_photo_secure_token, :string
    add_column :submissions, :sample_photo_secure_token, :string
  end
end
