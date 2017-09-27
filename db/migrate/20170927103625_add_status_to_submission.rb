class AddStatusToSubmission < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :status, :integer, default: 0
  end
end
