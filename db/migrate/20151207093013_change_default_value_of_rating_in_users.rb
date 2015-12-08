class ChangeDefaultValueOfRatingInUsers < ActiveRecord::Migration
  def up
    change_column_default :users, :rating, 0
  end

  def down
    change_column_default :users, :rating, nil
  end
end
