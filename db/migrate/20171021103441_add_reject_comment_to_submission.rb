class AddRejectCommentToSubmission < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :reject_comment, :string
  end
end
