class ChangeHealthScoreDataTypeToSubmissions < ActiveRecord::Migration[5.0]
  def change
    change_column :submissions, :health_score, :string
  end
end
