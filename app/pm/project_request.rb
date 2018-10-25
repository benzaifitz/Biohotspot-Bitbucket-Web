ActiveAdmin.register ProjectRequest, namespace: :pm do
  menu label: 'Project Requests', priority: 10
  actions :index

  index do
    selectable_column
    column 'User' do |pr|
      pr.user.email
    end
    column :project_id
    column :status

    actions do |pr|
      # (item 'Remove', remove_user_admin_project_path(pmp), class: 'member_link', method: :post) if pmp.project_manager.id != current_user.id
      # (item 'Re Invite', re_invite_user_admin_project_path(pmp), class: 'member_link', method: :post) if pmp.status == 'pending'
    end
  end

  filter :user, as: :select, collection: -> {User.where(id: ProjectRequest.where(project_id: current_project_manager.projects.pluck(:id)).pluck(:user_id)).collect{|user| [user.email, user.id]}}
  filter :project, as: :select, collection: -> {current_project_manager.projects}
  filter :status, as: :select, collection: -> { ProjectRequest.statuses }
end
