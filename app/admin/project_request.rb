ActiveAdmin.register ProjectRequest do
  menu label: 'Project Requests', priority: 10, parent: 'Users'
  actions :index

  index do
    selectable_column
    column 'User' do |pr|
      pr.user.full_name
    end
    column :project_id
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
      (item 'Accept', accept_join_request_admin_project_request_path(pr), class: 'member_link', method: :post) if pr.status == 'pending'
      (item 'Reject', reject_join_request_admin_project_request_path(pr), class: 'member_link', method: :post) if pr.status == 'pending'
    end
  end

  member_action :accept_join_request, method: :post do
    pr = ProjectRequest.find_by_id(params[:id])
    if pr && pr.status == 'pending'
      pmp = ProjectManagerProject.where(project_id: pr.project_id, project_manager_id: pr.user_id, status: 'pending').last
      if pmp
        pr.update_attributes({status: 'accepted'})
        pmp.update_attributes({status: 'accepted'})
        NotificationMailer.accept_project_joining_request(pr).deliver
      end
    end
    redirect_to admin_project_requests_path, :notice => 'Project joining request accepted' and return
  end

  member_action :reject_join_request, method: :post do
    pr = ProjectRequest.find_by_id(params[:id])
    if pr && pr.status == 'pending'
      pmp = ProjectManagerProject.where(project_id: pr.project_id, project_manager_id: pr.user_id, status: 'pending').last
      if pmp
        pr.update_attributes({status: 'rejected'})
        pmp.update_attributes({status: 'rejected'})
        NotificationMailer.reject_project_joining_request(pr).deliver
      end
    end
    redirect_to admin_project_requests_path, :notice => 'Project joining request rejected' and return
  end


  remove_filter :reason
  filter :user, as: :select, collection: -> {User.all.collect{|user| [user.full_name, user.id]}}
  filter :project
  filter :status, as: :select, collection: -> { ProjectRequest.statuses }
end
