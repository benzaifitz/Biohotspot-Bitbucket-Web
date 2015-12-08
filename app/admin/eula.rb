ActiveAdmin.register Eula, as: 'Terms And Condition' do

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
end
