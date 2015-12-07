class ChangeOfferedByInJobs < ActiveRecord::Migration
  def up
    rename_column :jobs, :offered_by, :offered_by_id
  end

  def down
    rename_column :jobs, :offered_by_id, :offered_by
  end
end
