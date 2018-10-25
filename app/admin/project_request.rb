ActiveAdmin.register ProjectRequest do
  menu label: 'Project Requests', priority: 10
  actions :index, :destroy

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



  filter :user, as: :select, collection: -> {User.all.collect{|user| [user.email, user.id]}}
  filter :project
  filter :status, as: :select, collection: -> { ProjectRequest.statuses }
end
