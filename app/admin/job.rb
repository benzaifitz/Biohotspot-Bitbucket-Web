ActiveAdmin.register Job do

  menu label: 'Job List', parent: 'Jobs', priority: 0

  actions :index

  index do
    id_column
    column :created_at
    column 'Staff Id', :offered_by_id
    column 'Staff', :offered_by
    column 'Staff Company' do |j|
      label j.offered_by.company
    end
    column :description
    column 'Customer Id', :user_id
    column 'Customer', :user
    column :status
  end


  filter :offered_by, label: 'Staff'
  filter :user, label: 'Customer'
  filter :status, as: :select, collection: -> { Job.statuses }
  filter :created_at

end
