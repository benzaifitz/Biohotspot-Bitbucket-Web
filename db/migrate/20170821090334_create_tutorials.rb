class CreateTutorials < ActiveRecord::Migration[5.0]
  def change
    create_table :tutorials do |t|

      t.string :avatar
      t.text :avatar_text

      t.timestamps
    end
  end
end
