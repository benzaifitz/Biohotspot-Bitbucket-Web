ActiveAdmin.register Job do

  menu label: 'Job List', parent: 'Jobs', priority: 0

  actions :index

  index do
    id_column
    column :created_at
    column 'Customer Id', :offered_by_id
    column 'Customer', :offered_by
    column 'Customer Company' do |j|
      label j.offered_by.company
    end
    column :description
    column 'Staff Id', :user_id
    column 'Staff', :user
    column :status
  end


  filter :offered_by, label: 'Customer'
  filter :user, label: 'Staff'
  filter :status, as: :select, collection: -> { Job.statuses }
  filter :created_at

end
