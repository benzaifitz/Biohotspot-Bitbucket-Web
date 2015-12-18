ActiveAdmin.register User, as: 'Staff' do

  menu false
  
  permit_params do
    allowed = []
    allowed.push :password if params[:user] && !params[:user][:password].blank?
    allowed += [:first_name, :last_name, :email, :company]
    allowed.uniq
  end

  actions :all, :except => [:index]

  form do |f|
    f.inputs 'Staff Details' do
      f.input :first_name
      f.input :last_name
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
    before_filter :check_duplicate_email, :only => :update

    def update
      super do |format|
        redirect_to admin_users_path, :notice => 'Staff updated successfully.' and return if resource.valid?
      end
    end

    def create
      super do |format|
        redirect_to admin_users_path, :notice => 'Staff created successfully.' and return if resource.valid?
      end
    end

    def check_duplicate_email
      if params[:user][:email] != resource.email && !User.find_by_email(params[:user][:email]).nil?
        redirect_to edit_admin_staff_path, alert: 'Duplicate email.' and return
      end
    end
  end

  controller do
    def scoped_collection
      User.where(user_type: User.user_types[:staff])
    end
  end
end