class AddStatusToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :status, :integer, index: true, default: 0, null: false
  end
end
