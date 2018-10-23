ActiveAdmin.register ProjectManagerProject, as: 'Project Users', namespace: :pm do

  actions :index

  index do
    selectable_column
    column 'User' do |pmp|
      User.find_by_id(pmp.project_manager_id).email
    end
    column :project_id
    column :is_admin
    column :status

    actions do |pmp|
      (item 'Remove', remove_user_pm_project_path(pmp), class: 'member_link', method: :post) if pmp.project_manager != current_project_manager
      (item 'Re Invite', re_invite_user_pm_project_path(pmp), class: 'member_link', method: :post) if pmp.status == 'pending'
    end
  end



  filter :project_manager
  filter :project, as: :select, collection: -> {current_project_manager.projects}
  filter :is_admin
  filter :status, as: :select, collection: -> { ProjectManagerProject.statuses }
end