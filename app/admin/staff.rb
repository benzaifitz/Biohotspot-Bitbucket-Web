ActiveAdmin.register User, as: 'Staff' do

  permit_params :name, :email, :company, :password
  actions :all, :except => [:index]

  form do |f|
    f.inputs 'Staff Details' do
      f.input :name
      f.input :email
      f.input :company
      f.input :password
    end
    f.actions do
      f.action(:submit)
      f.cancel_link(admin_users_path)
    end
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
        redirect_to admin_users_path, :notice => 'Staff updated successfully.'
      else
        render :edit
      end
    end

    def create
      super do |success,failure|
        success.html { redirect_to admin_users_path, :notice => 'Staff created successfully.' }
        failure.html { render :edit }
      end
    end

  end

  controller do
    def scoped_collection
      User.where(user_type: User.user_types[:staff])
    end
  end
end