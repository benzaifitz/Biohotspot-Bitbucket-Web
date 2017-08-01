ActiveAdmin.register Job, as: 'Job Events' do

  menu label: 'Job Events', parent: 'Jobs', priority: 1

  actions :index

  index do
    id_column
    column :created_at
    column 'Land Manager Id', :offered_by_id
    column 'Land Manager' do |je|
      link_to je.offered_by.username, admin_user_path(je.offered_by)
    end
    column 'Land Manager Company' do |j|
      label j.offered_by.company
    end
    column 'Project Manager Id', :user_id
    column 'Project Manager' do |je|
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


  filter :offered_by_username_cont, label: 'Land Manager(Username)'
  filter :offered_by_first_name_cont, label: 'Land Manager(First Name)'
  filter :offered_by_last_name_cont, label: 'Land Manager(Last Name)'
  filter :user_username_cont, label: 'Project Manager(Username)'
  filter :user_first_name_cont, label: 'Project Manager(First Name)'
  filter :user_last_name_cont, label: 'Project Manager(Last Name)'
  filter :status, as: :select, collection: -> { Job.statuses }
  filter :created_at

  controller do
    def scoped_collection
      super.includes(:offered_by, :user)
    end
  end
end
