ActiveAdmin.register User do

  permit_params :name, :email, :eula_id, :password, :user_type, :eula, :company, :rating, :status, :email

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
    actions
  end

  filter :name
  filter :email
  filter :user_type, as: :select, collection: -> { User.user_types.keys }
  filter :eula
  filter :company
  filter :rating
  filter :status


  form do |f|
    f.inputs "User Details" do
      f.input :name
      f.input :email
      f.input :user_type, as: :select, collection: User.user_types.keys
      f.input :eula
      f.input :company
      f.input :rating
      f.input :status
      f.input :email
      f.input :password
    end
    f.actions
  end

  controller do
    def update
      @user = User.find(params[:id])
      if permitted_params[:user][:password].blank?
        @user.update_without_password(permitted_params[:user])
      else
        @user.update_attributes(permitted_params[:user])
      end
      if @user.errors.blank?
        redirect_to admin_users_path, :notice => "User updated successfully."
      else
        render :edit
      end
    end
  end


end
