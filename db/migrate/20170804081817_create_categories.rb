class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :name, nil: false
      t.text :description, default: nil
      t.text :tags, default:nil
      t.string :class_name, default:nil
      t.string :family, default:nil
      t.string :location, default:nil
      t.string :url, default:nil
      t.references :site, index:true

      t.timestamps
    end
  end
end
