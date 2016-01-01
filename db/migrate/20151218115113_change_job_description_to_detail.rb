class ChangeJobDescriptionToDetail < ActiveRecord::Migration
  def change
    rename_column :jobs, :description, :detail
  end
end
