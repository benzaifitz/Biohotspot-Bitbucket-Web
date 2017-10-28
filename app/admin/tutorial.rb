ActiveAdmin.register Tutorial do

  menu label: 'Tutorial List', parent: 'Tutorial', priority: 13

  permit_params :avatar, :avatar_text
  actions :all

  form do |f|
    f.inputs do
      f.input :avatar, as: :file
      f.input :avatar_text
    end
    f.actions
  end

  index do
    selectable_column
    column :id
    column :avatar_text
    column :avatar do |u|
      image_tag "#{u.avatar.url}", style: "width: 20%"
    end
    column :created_at
    column :updated_at
    # TODO This will be implemented after adding categories model to system.

    actions do |tutorial|
    end
  end

  show do
    attributes_table do
      row :avatar do |u|
        image_tag "#{u.avatar.url}"
      end
      row :avatar_text
      row :created_at
      row :updated_at
    end
  end

end