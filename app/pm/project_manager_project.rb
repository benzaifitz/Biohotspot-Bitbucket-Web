ActiveAdmin.register ProjectManagerProject, as: 'Project Users', namespace: :pm do

  actions :index

  index do
    selectable_column
    column 'User', :project_manager_id
    column :project_id
    column :is_admin
    column :status

    actions do |pmp|
      (item 'Invite', re_invite_user_pm_project_path(pmp), class: 'member_link', method: :post) if pmp.status == 'pending'
    end
  end



  filter :project_manager
  filter :project, as: :select, collection: -> {current_project_manager.projects}
  filter :is_admin
  filter :status, as: :select, collection: -> { ProjectManagerProject.statuses }
  # remove_filter :token
  # filter :status, as: :select
end
