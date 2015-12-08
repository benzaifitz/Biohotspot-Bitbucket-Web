ActiveAdmin.register Eula, as: 'Terms And Condition' do

  permit_params :is_latest, :eula_text

  form do |f|
    inputs 'Terms and Conditions' do
      input :eula_text, as: :ckeditor, label: "Terms and Condition Text"
      input :is_latest
    end
    actions
  end
end
