class AddRejectCommentToPhoto < ActiveRecord::Migration[5.0]
  def change
    add_column :photos, :reject_comment, :string
  end
end
