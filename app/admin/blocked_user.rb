ActiveAdmin.register BlockedUser, as: 'Blocked Users' do
  actions :index

  index do
    column 'Blocked Date', :created_at
    column 'Blocked User Id', :user_id
    column 'Blocked User', :user
    column 'Blocked Status' do |bu|
      label bu.user.status
    end
    column 'Blocked By', :blocked_by
    column 'Blocked By Status' do |bu|
      label bu.blocked_by.status
    end
  end

end