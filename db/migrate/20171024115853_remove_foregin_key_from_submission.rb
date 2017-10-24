class RemoveForeginKeyFromSubmission < ActiveRecord::Migration[5.0]
  def up
    remove_foreign_key "submissions", "sub_categories"
  end

  def down
    add_foreign_key "submissions", "sub_categories"
  end
end
