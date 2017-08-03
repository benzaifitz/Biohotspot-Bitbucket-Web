class CreateSites < ActiveRecord::Migration[5.0]
  def change
    create_table :sites do |t|
      t.string :title, nil: false
      t.text :summary, default: nil
      t.text :tags, default: nil
      t.references :project, index:true

      t.timestamps
    end
  end
end
