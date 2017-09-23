class AddImageSecureTokenToPhoto < ActiveRecord::Migration[5.0]
  def change
    add_column :photos, :file_secure_token, :string
  end
end
