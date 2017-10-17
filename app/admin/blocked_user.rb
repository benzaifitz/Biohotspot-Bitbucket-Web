ActiveAdmin.register BlockedUser, as: 'Blocked Users' do

  menu label: 'Blocked Users', parent: 'Users', priority: 3

  actions :index

  filter :user_username_cont, label: 'Blocked By(Username)'
  filter :user_first_name_cont, label: 'Blocked By(First Name)'
  filter :user_last_name_cont, label: 'Blocked By(Last Name)'
  filter :blocked_by_username_cont, label: "Blocked User(Username)"
  filter :blocked_by_first_name_cont, label: "Blocked User(First Name)"
  filter :blocked_by_last_name_cont, label: "Blocked User(Last Name)"
  filter :created_at

  index do
    column 'Blocked Date', :created_at
    column 'Blocked User Id', :user_id
    column 'Blocked User' do |bu|
      link_to bu.user.username, admin_user_path(bu.user)
    end
    column 'Blocked Users Status' do |bu|
      label bu.user.status
    end
    column 'Blocked By' do |bu|
      link_to bu.blocked_by.username, admin_user_path(bu.blocked_by)
    end
    column 'Blocked By Users Status' do |bu|
      label bu.blocked_by.status
    end
  end

end