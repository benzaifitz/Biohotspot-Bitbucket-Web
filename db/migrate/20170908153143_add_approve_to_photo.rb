class AddApproveToPhoto < ActiveRecord::Migration[5.0]
  def change
    add_column :photos, :approved, :boolean, default: true
  end
end
