class CreateEulas < ActiveRecord::Migration
  def change
    create_table :eulas do |t|
      t.text :eula_text
      t.boolean :is_latest, default: false
      t.timestamps null: false
    end
  end
end
