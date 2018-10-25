class AddReasonToProjectRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :project_requests, :reason, :text
  end
end
