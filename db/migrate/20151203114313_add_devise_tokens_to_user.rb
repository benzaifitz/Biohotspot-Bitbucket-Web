class AddDeviseTokensToUser < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.string :provider, :null => false, :default => "email"
      t.string :uid, :null => false, :default => ""
      ## Tokens
      t.json :tokens
    end
  end
end
