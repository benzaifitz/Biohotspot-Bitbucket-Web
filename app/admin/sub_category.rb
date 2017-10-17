ActiveAdmin.register SubCategory, as: 'Sample' do

  menu label: 'Sample List', parent: 'Species', priority: 3

  permit_params do
    [:name, :category_id]
  end

  actions :all

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Administrator Details' do
      f.input :name
      f.input :category_id, as: :select, collection: Category.all.map{|a| [a.name, a.id]}
      # f.input :user_id, label: 'Land Manager', as: :select, collection: User.project_manager.all.map{|a| [a.email, a.id]}
    end
    f.actions do
      f.action(:submit)
      f.cancel_link(admin_users_path)
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :category_id
    # column 'Land Manager',:user_id do |category|
    #   link_to category.user.email, admin_user_path(category.user_id) if category.user.present?
    # end
    column :created_at
    column :updated_at
    actions
  end

  show do |category|
    attributes_table do
      row :id
      row :name
      row :category_id
      # row :user_id do
      #   link_to category.user.email, admin_user_path(category.user_id) if category.user.present?
      # end
      row :created_at
      row :updated_at
    end
  end
end