class AddAddressToSubmission < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :address, :string
  end
end
