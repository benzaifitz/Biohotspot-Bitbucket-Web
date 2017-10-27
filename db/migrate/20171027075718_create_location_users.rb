class CreateLocationUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :location_users do |t|
      t.integer :location_id
      t.integer :user_id

      t.timestamps
    end
  end
end
