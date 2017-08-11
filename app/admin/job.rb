ActiveAdmin.register Job do

  menu false
  # menu label: 'Job List', parent: 'Jobs', priority: 0

  actions :index

  index do
    id_column
    column :created_at
    column 'Land Manager Id', :offered_by_id
    column 'Land Manager'do |j|
      link_to j.offered_by.username, admin_user_path(j.offered_by)
    end
    column 'Land Manager Company' do |j|
      label j.offered_by.company
    end
    column :detail
    column 'Project Manager Id', :user_id
    column 'Project Manager'do |j|
      link_to j.user.username, admin_user_path(j.user)
    end
    column :status
  end


  filter :offered_by_username_cont, label: 'Land Manager(Username)'
  filter :offered_by_first_name_cont, label: 'Land Manager(First Name)'
  filter :offered_by_last_name_cont, label: 'Land Manager(Last Name)'
  filter :user_username_cont, label: 'Project Manager(Username)'
  filter :user_first_name_cont, label: 'Project Manager(First Name)'
  filter :user_last_name_cont, label: 'Project Manager(Last Name)'
  filter :detail, label: 'Job Description'
  filter :status, as: :select, collection: -> { Job.statuses }
  filter :created_at

  controller do
    def scoped_collection
      super.includes(:offered_by, :user)
    end
  end
end
