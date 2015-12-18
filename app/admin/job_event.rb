ActiveAdmin.register Job, as: 'Job Events' do

  menu label: 'Job Events', parent: 'Jobs', priority: 1

  actions :index

  index do
    id_column
    column :created_at
    column 'Customer Id', :offered_by_id
    column 'Customer', :offered_by
    column 'Customer Company' do |j|
      label j.offered_by.company
    end
    column 'Staff Id', :user_id
    column 'Staff', :user
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


  filter :offered_by, label: 'Customer'
  filter :user, label: 'Staff'
  filter :status, as: :select, collection: -> { Job.statuses }
  filter :created_at
end
