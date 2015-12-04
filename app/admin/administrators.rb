ActiveAdmin.register User, as: 'Administrators' do


  permit_params :name, :email, :company
  actions :all, :except => [:index]

  form do |f|
    f.inputs 'Administrator Details' do
      f.input :name
      f.input :email
      f.input :company
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
        redirect_to admin_users_path, :notice => 'Admin updated successfully.'
      else
        render :edit
      end
    end
  end

  controller do
    def scoped_collection
      User.where(user_type: User.user_types[:administrator])
    end
  end

end