class CreateUserContentStatuses < ActiveRecord::Migration
  def change
    create_table :user_content_statuses do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
