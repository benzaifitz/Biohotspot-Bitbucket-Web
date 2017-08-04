class CreatePhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :photos do |t|
      t.references :category, index:true
      t.string :file
      t.string :url, default:nil

      t.timestamps
    end
  end
end
