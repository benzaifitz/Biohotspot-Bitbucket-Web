ActiveAdmin.register Eula, as: 'Terms And Condition' do

  filter :is_latest
  filter :created_at
  
  permit_params :is_latest, :eula_text

  form do |f|
    inputs 'Terms and Conditions (EULA)' do
      input :eula_text, as: :ckeditor, label: "Terms and Condition Text"
      input :is_latest
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row (:eula_text) {|eula| raw eula.eula_text}
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
