ActiveAdmin.register User, namespace: :pm  do
  include SharedPM

  menu label: 'User List', parent: 'Users', priority: 1

  actions :index, :show, :destroy

  action_item :view, only: :index do
    link_to 'New Land Manager', new_pm_land_manager_path
  end

  index do
    selectable_column
    id_column
    column :username do |user|
      link_to user.username, pm_user_path(user)
    end
    column :email
    column :mobile do |c|
      c.mobile_number
    end
    column :first_name
    column :last_name
    column :user_type do |u|
      if u.land_manager?
        status_tag('active', :ok, class: 'green', label: u.user_type.humanize.upcase)
      elsif u.project_manager?
        status_tag('eactiverror', :ok, class: 'orange', label: u.user_type.humanize.upcase)
      else
        status_tag('error', :ok, class: 'important', label: 'UNKNOWN')
      end
    end
    column :status do |u|
      if u.active?
        status_tag('active', :ok, class: 'green', label: u.status.humanize.upcase)
      elsif u.banned?
        status_tag('eactiverror', :ok, class: 'red', label: u.status.humanize.upcase)
      else
        status_tag('active', :ok, class: 'orange', label: (u.user_type.humanize.upcase rescue nil) )
      end
    end
    column :last_sign_in_at
    # TODO This will be implemented after adding categories model to system.
    # column :assigned_sub_categories do |c|
    #   "--"
    # end
    column :location do |u|
      if u.land_manager?
        locations = u.locations.map do |l|
          link_to(l.name,pm_location_path(l.id)) rescue nil
        end
        locations.compact.join("  ").html_safe

      end
    end
    column :project do |u|
      if !u.land_manager?
        pm = ProjectManager.find(u.id)
        projects = pm.projects.map do |p|
          link_to(p.title,pm_project_path(p.id)) rescue nil
        end
        projects.compact.join("  ").html_safe
      end
    end
    actions do |user|
      item 'Edit', eval("edit_pm_#{user.user_type}_path(#{user.id})"), class: 'member_link'
      (item 'Disable', confirm_status_change_pm_user_path(user, status_change_action: 'disable'), class: 'fancybox member_link', data: { 'fancybox-type' => 'ajax' }) if user.active?
      (item 'Enable', confirm_status_change_pm_user_path(user, status_change_action: 'enable'), class: 'fancybox member_link', data: { 'fancybox-type' => 'ajax' }) if user.banned?
      (item 'Promote', promote_to_project_manager_pm_land_manager_path(user), method: :put, class: 'member_link') if user.land_manager?
      item 'Events', "#{pm_user_events_path}?q[item_id_eq]=#{user.id}"
    end
  end

  show do
    attributes_table do
=begin
      row :profile_picture do |u|
        image_tag "#{u.profile_picture.url}?#{Random.rand(100)}"
      end
=end
      row :email
      row :username
      row :company
      row :first_name
      row :last_name
      row :user_type
      row :status
      row :rating
      row :number_of_ratings
      row :eula
      row :device_token
      row :sign_in_count
      row :last_sign_in_at
      row :current_sign_in_at
      row :confirmed_at
      row :reset_password_sent_at
      row :created_at
      row :updated_at
    end
  end

  csv do
    column :id
    column :first_name
    column :last_name
    column :email
    column :user_type
    column :company
    column :status
    column :rating
    column :number_of_ratings
    column :eula
    column :sign_in_count
    column :last_sign_in_at
    column :current_sign_in_at
    column :confirmed_at
    column :reset_password_sent_at
    column :created_at
    column :updated_at
  end

  filter :first_name
  filter :last_name
  filter :email
  filter :username
  filter :user_type, as: :select, collection: -> { User.user_types }
  filter :company
  filter :last_sign_in_at
  filter :status, as: :select, collection: -> { User.statuses }
end
