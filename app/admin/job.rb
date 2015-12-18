ActiveAdmin.register Job do

  menu label: 'Job List', parent: 'Jobs', priority: 0

  actions :index

  index do
    id_column
    column :created_at
    column 'Staff Id', :offered_by_id
    column 'Staff' do |j|
      link_to j.offered_by.username, admin_user_path(j.offered_by)
    end
    column 'Staff Company' do |j|
      label j.offered_by.company
    end
    column 'Customer Id', :user_id
    column 'Customer' do |j|
      link_to j.user.username, admin_user_path(j.user)
    end
    column :status
  end


  filter :offered_by, label: 'Staff'
  filter :user, label: 'Customer'
  filter :status, as: :select, collection: -> { Job.statuses }
  filter :created_at

end
