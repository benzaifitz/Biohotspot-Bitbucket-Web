class AddApprovedToSubmission < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :approved, :boolean, default: true
  end
end
