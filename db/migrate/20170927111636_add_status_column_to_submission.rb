class AddStatusColumnToSubmission < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :status, :integer, default: 1
  end
end
