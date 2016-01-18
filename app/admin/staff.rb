ActiveAdmin.register User, as: 'Staff' do

  menu false
  
  permit_params do
    allowed = []
    allowed.push :password if params[:user] && !params[:user][:password].blank?
    allowed += [:first_name, :last_name, :email, :company, :profile_picture, :profile_picture_cache, :username]
    allowed.uniq
  end

  actions :all, :except => [:index]

  form do |f|
    f.inputs 'Staff Details' do
      f.input :email
      f.input :password
      f.input :username, hint: 'Allowed characters are A to Z, a to z, 0 to 9 and _(underscore)'
      f.input :company
      f.input :first_name
      f.input :last_name
      f.inputs "Profile Picture", :multipart => true do
        f.input :profile_picture, :as => :file, :hint => image_tag(f.object.profile_picture.url)
        f.input :profile_picture_cache, :as => :hidden
      end
    end
    f.actions do
      f.action(:submit)
      f.cancel_link(admin_users_path)
    end
  end

  controller do
    def update
      super do |format|
        redirect_to admin_users_path, :notice => 'Staff updated successfully.' and return if resource.valid?
      end
    end

    def create
      super do |format|
        if resource.valid?
          resource.send_confirmation_instructions
          redirect_to admin_users_path, :notice => 'Staff created successfully.' and return
        end
      end
    end
  end

  controller do
    def scoped_collection
      User.where(user_type: User.user_types[:staff])
    end
  end
end