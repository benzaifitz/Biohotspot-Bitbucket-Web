class CreatePrivacies < ActiveRecord::Migration
  def change
    create_table :privacies do |t|
      t.text :privacy_text
      t.boolean :is_latest, default: false
      t.timestamps null: false
    end
  end
end
