ActiveAdmin.register Job, as: 'Job Events' do

  menu label: 'Job Events', parent: 'Jobs', priority: 1

  actions :index

  index do
    id_column
    column :created_at
    column 'Staff Id', :offered_by_id
    column 'Staff' do |je|
      link_to je.offered_by.username, admin_user_path(je.offered_by)
    end
    column 'Staff Company' do |j|
      label j.offered_by.company
    end
    column 'Customer Id', :user_id
    column 'Customer' do |je|
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


  filter :offered_by
  filter :user, label: 'Customer'
  filter :status, as: :select, collection: -> { Job.statuses }
  filter :created_at
end
