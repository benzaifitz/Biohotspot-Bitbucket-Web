ActiveAdmin.register Job do

  actions :index

  index do
    column :created_at
    id_column
    column 'Staff Id', :offered_by_id
    column 'Staff', :offered_by
    column 'Staff Company' do |j|
      label j.offered_by.company
    end
    column 'Customer Id', :user_id
    column 'Customer', :user
    column :status
  end

end