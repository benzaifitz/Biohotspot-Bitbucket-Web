class DropJobStatusTable < ActiveRecord::Migration
  def change
    remove_column :jobs, :job_status_id
    add_column :jobs, :status, :integer, default: 0
    drop_table :job_statuses
  end
end
