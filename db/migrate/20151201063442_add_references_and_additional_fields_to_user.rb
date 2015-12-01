class AddReferencesAndAdditionalFieldsToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      # references
      t.belongs_to :user_status
      t.belongs_to :user_type
      t.belongs_to :eula
      
      # additional fields
      t.string :first_name
      t.string :last_name
      t.string :company
      t.decimal :rating 
    end
  end
end
