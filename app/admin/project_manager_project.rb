ActiveAdmin.register ProjectManagerProject, as: 'Project Users' do
  menu label: 'Project Users', parent: 'Users', priority: 4
  actions :index

  index do
    selectable_column
    column 'User' do |pmp|
      User.find_by_id(pmp.project_manager_id).full_name
    end
    column :project_id
    column :is_admin
    column :status

    actions do |pmp|
      (item 'Remove', remove_user_admin_project_path(pmp), class: 'member_link', method: :post) if pmp.project_manager.id != current_user.id
      (item 'Re Invite', re_invite_user_admin_project_path(pmp), class: 'member_link', method: :post) if pmp.status == 'pending'
    end
  end



  filter :project_manager
  filter :project
  filter :is_admin
  filter :status, as: :select, collection: -> { ProjectManagerProject.statuses }
end
