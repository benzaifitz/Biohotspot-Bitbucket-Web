class RemoveStatusColumnFromSubmission < ActiveRecord::Migration[5.0]
  def up
    remove_column :submissions, :status, :integer
  end

  def down
    add_column :submissions, :status, :integer
  end
end
