ActiveAdmin.register ProjectRequest, namespace: :pm do
  menu label: 'Project Requests', priority: 10
  actions :index

  index do
    selectable_column
    column 'User' do |pr|
      pr.user.email
    end
    column :project_id
    column :reason
    column :status do |pmp|
      if pmp.status == 'accepted'
        status_tag('active', :ok, class: 'green', label: 'Accepted')
      elsif pmp.status == 'rejected'
        status_tag('active', :ok, class: 'red', label: 'Rejected')
      elsif pmp.status == 'pending'
        status_tag('active', :ok, class: 'orange', label: 'Pending')
      end
    end

    actions do |pr|
      (item 'Accept', accept_join_request_pm_project_request_path(pr), class: 'member_link', method: :post) if pr.status == 'pending'
      (item 'Reject', reject_join_request_pm_project_request_path(pr), class: 'member_link', method: :post) if pr.status == 'pending'
    end
  end

  member_action :accept_join_request, method: :post do
    pr = ProjectRequest.find_by_id(params[:id])
    if pr && pr.status == 'pending'
      pmp = ProjectManagerProject.where(project_id: pr.project_id, project_manager_id: pr.user_id, status: 'pending').last
      if pmp
        pr.update_attributes({status: 'accepted'})
        pmp.update_attributes({status: 'accepted'})
      end
    end
    redirect_to pm_project_requests_path, :notice => 'Project joining request accepted' and return
  end

  member_action :reject_join_request, method: :post do
    pr = ProjectRequest.find_by_id(params[:id])
    if pr && pr.status == 'pending'
      pmp = ProjectManagerProject.where(project_id: pr.project_id, project_manager_id: pr.user_id, status: 'pending').last
      if pmp
        pr.update_attributes({status: 'rejected'})
        pmp.update_attributes({status: 'rejected'})
      end
    end
    redirect_to pm_project_requests_path, :notice => 'Project joining request rejected' and return
  end


  remove_filter :reason
  filter :user, as: :select, collection: -> {User.where(id: ProjectRequest.where(project_id: current_project_manager.projects.pluck(:id)).pluck(:user_id)).collect{|user| [user.email, user.id]}}
  filter :project, as: :select, collection: -> {current_project_manager.projects}
  filter :status, as: :select, collection: -> { ProjectRequest.statuses }
end
