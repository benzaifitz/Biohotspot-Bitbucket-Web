class AddMobileNumberToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :mobile_number, :string, default: nil
  end
end
