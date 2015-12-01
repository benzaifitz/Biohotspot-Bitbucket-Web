class CreateReportedRatings < ActiveRecord::Migration
  def change
    create_table :reported_ratings do |t|
      t.references :rating, index: true, foreign_key: true
      t.integer :reported_by_id, null: false
      t.timestamps null: false
    end
  end
end
