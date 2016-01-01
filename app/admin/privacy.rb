ActiveAdmin.register Privacy, as: 'Privacy Policy' do

  menu label: 'Privacy Policy', parent: 'License', priority: 1

  permit_params :privacy_text

  actions :all, except: [ :edit, :update ]

  filter :is_latest
  filter :created_at

  form do |f|
    inputs 'Privacy Policy' do
      input :privacy_text, as: :ckeditor, label: "Privacy Policy Text"
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row (:privacy_text) do |privacy|
        raw privacy.privacy_text
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
      privacy = Privacy.find(params[:id])
      unless privacy.is_latest
        privacy.destroy!
        redirect_to admin_privacy_policies_path, notice: 'Privacy policy has been deleted successfully.'
      else
        redirect_to admin_privacy_policies_path, flash: { error: 'Latest Privacy Policy cannot be deleted.' }
      end
    end

    def create
      privacy_policy = Privacy.new(permitted_params[:privacy].merge(is_latest: true))
      if privacy_policy.save
        redirect_to admin_privacy_policy_path(privacy_policy), notice: 'Privacy policy has been created successfully.'
      else
        redirect_to admin_privacy_policies_path, flash: { error: 'Privacy policy could not be created.' }
      end
    end
  end

  batch_action :destroy, method: :delete, confirm: "Are you sure you want to delete these privacy policies?" do |ids|
    deleted_privacy_count = Privacy.where("id in (?) and is_latest = ?", ids, false).delete_all
    redirect_to admin_privacy_policies_path, notice: "#{deleted_privacy_count} privacy policies deleted."
  end
end
