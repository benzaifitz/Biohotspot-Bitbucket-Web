class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.references :job_status, index: true
      t.references :user, foreign_key: true, index: true
      t.integer :offered_by, null: false
      t.timestamps null: false
    end
  end
end
