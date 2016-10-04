ActiveAdmin.register Job, as: 'Job Events' do

  menu label: 'Job Events', parent: 'Jobs', priority: 1

  actions :index

  index do
    id_column
    column :created_at
    column 'Customer Id', :offered_by_id
    column 'Customer' do |je|
      link_to je.offered_by.username, admin_user_path(je.offered_by)
    end
    column 'Customer Company' do |j|
      label j.offered_by.company
    end
    column 'Staff Id', :user_id
    column 'Staff' do |je|
      link_to je.user.username, admin_user_path(je.user)
    end
    column :status
    actions do |r|
      item 'History', history_admin_job_event_path(r), class: 'job_history_link member_link', data: {id: r.id}, remote: true
    end
  end

  member_action :history do
    @id = params[:id]
    job = Job.find(@id)
    @versions = job.versions.to_a
  end


  filter :offered_by_username_cont, label: 'Customer(Username)'
  filter :offered_by_first_name_cont, label: 'Customer(First Name)'
  filter :offered_by_last_name_cont, label: 'Customer(Last Name)'
  filter :user_username_cont, label: 'Staff(Username)'
  filter :user_first_name_cont, label: 'Staff(First Name)'
  filter :user_last_name_cont, label: 'Staff(Last Name)'
  filter :status, as: :select, collection: -> { Job.statuses }
  filter :created_at

  controller do
    def scoped_collection
      super.includes(:offered_by, :user)
    end
  end
end
