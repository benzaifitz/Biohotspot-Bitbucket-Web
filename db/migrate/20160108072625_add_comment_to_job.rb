class AddCommentToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :comment, :string
  end
end
