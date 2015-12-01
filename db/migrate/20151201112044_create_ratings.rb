class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.decimal :rating
      t.text :comment
      t.references :user_content_status, foreign_key: true, index: true
      t.references :user, foreign_key: true, index: true
      t.integer :rated_on_id, null: false
      t.timestamps null: false
    end
  end
end
