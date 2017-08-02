class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :title, nil: false
      t.text :summary, default: nil
      t.text :tags, default: nil
      t.string :client_name, default: nil

      t.timestamps
    end
  end
end
