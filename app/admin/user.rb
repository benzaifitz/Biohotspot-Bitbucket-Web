ActiveAdmin.register User do

  actions :index, :show

  action_item :view, only: :index do
    link_to 'New Customer', new_admin_customer_path
  end
  action_item :view, only: :index do
    link_to 'New Staff', new_admin_staff_path
  end
  index do
    selectable_column
    id_column
    column :name
    column :email
    column :user_type
    column :eula
    column :company
    column :rating
    column :status
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions do |user|
      link_to 'Edit', eval("edit_admin_#{user.user_type}_path(#{user.id})"), class: 'member_link'
    end
  end

  filter :name
  filter :email
  filter :user_type, as: :select, collection: -> { User.user_types.keys }
  filter :eula
  filter :company
  filter :rating
  filter :status



end
