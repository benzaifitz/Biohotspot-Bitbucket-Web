ActiveAdmin.register BlockedUser, as: 'Blocked Users' do
  actions :index

  controller do
    def scoped_collection
      # BlockedUser.select('max(created_at) as created_at, user_id, blocked_by').group(:user_id, :blocked_by).order('created_at desc')
      # BlockedUser.select("DISTINCT ON (user_id) *")
      BlockedUser.select("DISTINCT ON(user_id) *").order("user_id, created_at DESC")
    end
  end

  index do
    column 'Blocked Date', :created_at
    column 'Blocked User Id', :user_id
    column 'Blocked User', :user
    column 'Blocked By', :blocked_by
    column 'Blocked By Status' do |bu|
      label bu.blocked_by.status
    end
    # do |bu|
    #   label bu.user.name
    # end
  end

end