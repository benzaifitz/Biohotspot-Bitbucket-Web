ActiveAdmin.register User do

  actions :index, :show, :destroy

  action_item :view, only: :index do
    link_to 'New Customer', new_admin_customer_path
  end
  action_item :view, only: :index do
    link_to 'New Staff', new_admin_staff_path
  end

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :user_type
    column :company
    column :last_sign_in_at
    column :status
    actions do |user|
      # link_to 'Edit', eval("edit_admin_#{user.user_type}_path(#{user.id})"), class: 'member_link'
      item 'Edit', eval("edit_admin_#{user.user_type}_path(#{user.id})"), class: 'member_link'
      (item 'Ban', ban_admin_user_path(user), class: 'member_link', method: :put) if user.active?
      (item 'Enable', enable_admin_user_path(user), class: 'member_link', method: :put) if user.banned?
      item 'Events', '#'
    end

  end

  filter :firstname
  filter :last_name
  filter :email
  filter :user_type, as: :select, collection: -> { User.user_types.keys }
  filter :company
  filter :last_sign_in_at
  filter :status

  member_action :ban, method: :put do
    resource.banned!
    redirect_to admin_users_path, notice: 'User Banned!'
  end

  member_action :enable, method: :put do
    resource.active!
    redirect_to admin_users_path, notice: 'User Enabled!'
  end

end
