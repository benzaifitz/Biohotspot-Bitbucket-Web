class CreateSubmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :submissions do |t|
      t.string :survey_number
      t.integer :submitted_by, index: true
      t.boolean :lat, default: nil
      t.boolean :long, default: nil
      t.references :sub_category, foreign_key: true
      t.string :rainfall, default: nil
      t.string :humidity, default: nil
      t.string :temperature, default: nil
      t.float :health_score, default: nil
      t.string :live_leaf_cover, default: nil
      t.string :live_branch_stem, default: nil
      t.float :stem_diameter, default: nil

      t.timestamps
    end
  end
end
