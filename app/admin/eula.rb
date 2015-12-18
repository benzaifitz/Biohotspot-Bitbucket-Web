ActiveAdmin.register Eula, as: 'Terms And Condition' do

  menu label: 'Terms and Conditions', parent: 'License', priority: 0

  permit_params :eula_text

  actions :all, except: [ :edit, :update ]

  filter :is_latest
  filter :created_at

  form do |f|
    inputs 'Terms and Conditions (EULA)' do
      input :eula_text, as: :ckeditor, label: "Terms and Condition Text"
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row (:eula_text) do |eula|
        raw eula.eula_text
      end
      row :is_latest
      row :created_at
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

  controller do
    def destroy
      eula = Eula.find(params[:id])
      unless eula.is_latest
        eula.destroy!
        redirect_to admin_terms_and_conditions_path, notice: 'Terms and Conditions deleted successfully.'
      else
        redirect_to admin_terms_and_conditions_path, flash: { error: 'Latest Terms and Conditions cannot be deleted.' }
      end
    end

    def create
      eula = Eula.new(permitted_params[:eula].merge(is_latest: true ))
      if eula.save
        Eula.where('id != ?', eula.id).update_all(is_latest: false)
        redirect_to admin_terms_and_condition_path(eula), notice: 'Terms and Conditions created successfully.'
      else
        redirect_to admin_terms_and_conditions_path, flash: { error: 'Terms and conditions could not be created.' }
      end
    end
  end

  batch_action :destroy, method: :delete, confirm: "Are you sure you want to delete these Terms and Conditions?" do |ids|
    deleted_eulas_count = Eula.where("id in (?) and is_latest = ?", ids, false).delete_all
    redirect_to admin_terms_and_conditions_path, notice: "#{deleted_eulas_count} Terms and Conditions deleted."
  end
end
