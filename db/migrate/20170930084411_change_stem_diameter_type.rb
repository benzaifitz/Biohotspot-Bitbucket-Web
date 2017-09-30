class ChangeStemDiameterType < ActiveRecord::Migration[5.0]
  def up
    change_column :submissions, :stem_diameter, :string
  end

  def down
    change_column :submissions, :stem_diameter, :float
  end
end
