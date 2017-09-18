class CreateFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :feedbacks do |t|
      t.text :comment
      t.integer :land_manager_id
      t.integer :project_id

      t.timestamps
    end
  end
end
