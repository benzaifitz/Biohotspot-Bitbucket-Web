ActiveAdmin.register Privacy, as: 'Privacy Policy' do

  filter :is_latest
  filter :created_at

  permit_params :is_latest, :privacy_text

  form do |f|
    inputs 'Privacy Policy' do
      input :privacy_text, as: :ckeditor, label: "Privacy Policy Text"
      input :is_latest
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row (:privacy_text) {|privacy| raw privacy.privacy_text}
      row :is_latest
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  index do
    selectable_column
    id_column
    column :is_latest
    column :created_at
    actions
  end
end
