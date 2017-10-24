class ChangeStatusDefaultInSubmission < ActiveRecord::Migration[5.0]
  def up
    change_column_default :submissions, :status, 0
  end

  def down
    change_column_default :submissions, :status, nil
  end
end
