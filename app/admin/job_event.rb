ActiveAdmin.register Job, as: 'Job Events' do

  actions :index

  index do
    id_column
    column :created_at
    column 'Staff Id', :offered_by_id
    column 'Staff', :offered_by
    column 'Staff Company' do |j|
      label j.offered_by.company
    end
    column 'Customer Id', :user_id
    column 'Customer', :user
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

end