class AddPrivacyIdToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.belongs_to :privacy
    end
  end
end
