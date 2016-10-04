class AddJobIdToRating < ActiveRecord::Migration
  def change
    add_column :ratings, :job_id, :integer, default: nil

    add_index :ratings, :job_id
  end
end
