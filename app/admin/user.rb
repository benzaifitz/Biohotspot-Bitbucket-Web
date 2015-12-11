ActiveAdmin.register User do

  actions :index, :show, :destroy

  action_item :view, only: :index do
    link_to 'New Customer', new_admin_customer_path
  end
  action_item :view, only: :index do
    link_to 'New Staff', new_admin_staff_path
  end

  action_item :view, only: :index do
    link_to 'New Administrator', new_admin_administrator_path
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
      item 'Edit', eval("edit_admin_#{user.user_type}_path(#{user.id})"), class: 'member_link'
      (item 'Ban', ban_admin_user_path(user), class: 'member_link', method: :put) if user.active?
      (item 'Enable', enable_admin_user_path(user), class: 'member_link', method: :put) if user.banned?
      item 'Events', "#{admin_user_events_path}?q[item_id_eq]=#{user.id}"
    end
  end

  show do
    attributes_table do
      row :first_name
      row :last_name
      row :email
      row :user_type
      row :company
      row :status
      row :rating
      row :number_of_ratings
      row :eula
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
  filter :user_type, as: :select, collection: -> { User.user_types }
  filter :company
  filter :last_sign_in_at
  filter :status, as: :select, collection: -> { User.statuses }

  member_action :ban, method: :put do
    resource.banned!
    redirect_to admin_users_path, notice: 'User Banned!'
  end

  member_action :enable, method: :put do
    resource.active!
    redirect_to admin_users_path, notice: 'User Enabled!'
  end

end
