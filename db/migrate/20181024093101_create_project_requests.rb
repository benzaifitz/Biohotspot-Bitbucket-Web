class CreateProjectRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :project_requests do |t|
      t.integer :project_id
      t.integer :user_id
      t.integer :status, :integer, index: true, default: 2, null: false
      t.references :project, index: true
      t.references :user, index: true
      t.timestamps
    end
  end
end
