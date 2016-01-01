class AddUuidIphoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uuid_iphone, :string
  end
end
