ActiveAdmin.register BlockedUser, as: 'Blocked Users' do

  menu label: 'Blocked Users', parent: 'Users', priority: 2

  actions :index

  index do
    column 'Blocked Date', :created_at
    column 'Blocked User Id', :user_id
    column 'Blocked User' do |bu|
      link_to bu.user.username, admin_user_path(bu.user)
    end
    column 'Blocked Status' do |bu|
      label bu.user.status
    end
    column 'Blocked By' do |bu|
      link_to bu.blocked_by.username, admin_user_path(bu.blocked_by)
    end
    column 'Blocked By Status' do |bu|
      label bu.blocked_by.status
    end
  end

end