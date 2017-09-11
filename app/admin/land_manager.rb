ActiveAdmin.register LandManager, as: 'Land Manager' do

  menu false

  actions :all, :except => [:index]


  permit_params do
    allowed = []
    allowed.push :password if params[:user] && !params[:user][:password].blank?
    allowed += [:first_name, :last_name, :email, :mobile_number, :company, :profile_picture,
                :profile_picture_cache, :username, sub_category_ids: []]
    allowed.uniq
  end

  actions :all, :except => [:index]

  form do |f|
    f.inputs 'Land Manager Details' do
      f.input :email
      f.input :mobile_number
      f.input :password
      f.input :username, hint: 'Allowed characters are A to Z, a to z, 0 to 9 and _(underscore)'
      # f.input :company
      f.input :first_name
      f.input :last_name
      f.input :sub_categories
      # f.input :project
=begin
      f.inputs "Profile Picture", :multipart => true do
        f.input :profile_picture, :as => :file, :hint => f.object[:profile_picture]
        f.input :profile_picture_cache, :as => :hidden
        insert_tag(Arbre::HTML::Li, class: 'file input optional') do
          insert_tag(Arbre::HTML::P, class: 'inline-hints') do
            insert_tag(Arbre::HTML::Img, id: 'profile_picture_preview', height: '48px', width: '48px', src: "#{f.object.profile_picture.url}?#{Random.rand(100)}")
          end
        end
      end
=end
    end
    f.actions do
      f.action(:submit)
      f.cancel_link(admin_users_path)
    end
  end

  controller do
    def update
      super do |format|
        redirect_to admin_users_path, :notice => 'Land Manager updated successfully.' and return if resource.valid?
      end
    end

    def create
      super do |format|
        if resource.valid?
          resource.send_confirmation_instructions
          redirect_to admin_users_path, :notice => 'Land Manager created successfully.' and return
        end
      end
    end
  end

  member_action :promote_to_project_manager, method: :put do
    resource.update_attributes!(user_type: User.user_types['project_manager'])
    redirect_to admin_users_path, :notice => 'User Promoted to Project Manager successfully.' and return
  end

end