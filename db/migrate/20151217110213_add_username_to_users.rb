class AddUsernameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :username, :string, null: false, default: ''
    User.reset_column_information
    User.all.each_with_index do |user, index|
      user.username = user.full_name.blank? ? user.email.gsub(/[^0-9A-Za-z]/, '') : "#{user.full_name.gsub(/ /, "")}_#{index}"
      user.company = 'Testing Company' if user.staff?
      user.save
    end
    add_index :users, :username, unique: true
  end

  def self.down
    remove_column :users, :username
  end
end
