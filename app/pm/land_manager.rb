ActiveAdmin.register LandManager, as: 'Land Manager', namespace: :pm  do

  menu false

  actions :all, :except => [:index]


  permit_params do
    allowed = []
    allowed.push :password if params[:land_manager] && !params[:land_manager][:password].blank?
    allowed += [:first_name, :last_name, :email, :mobile_number, :company, :profile_picture,
                :profile_picture_cache, :username, location_ids: []]
    allowed.uniq
  end

  actions :all, :except => [:index]

  form do |f|
    f.inputs 'Land Manager Details' do
      f.input :email
      f.input :mobile_number
      f.input :password, input_html: {autocomplete: 'new-password'}
      f.input :username, hint: 'Allowed characters are A to Z, a to z, 0 to 9 and _(underscore)'
      # f.input :company
      f.input :first_name
      f.input :last_name
      # f.input :sub_categories
      f.input :locations, as: :select, :multiple => true
      f.inputs "Profile Picture", :multipart => true do
        f.input :profile_picture, :as => :file, :hint => f.object[:profile_picture]
        f.input :profile_picture_cache, :as => :hidden
        insert_tag(Arbre::HTML::Li, class: 'file input optional') do
          insert_tag(Arbre::HTML::P, class: 'inline-hints') do
            insert_tag(Arbre::HTML::Img, id: 'picture_preview', height: '100px', width: '100px', src: "#{f.object.profile_picture.url(:thumb)}?#{Random.rand(100)}")
          end
        end
      end
    end
    f.actions do
      f.action(:submit)
      f.cancel_link(pm_users_path)
    end
  end

  controller do
    def update
      super do |format|
        redirect_to pm_users_path, :notice => 'Land Manager updated successfully.' and return if resource.valid?
      end
    end

    def create
      super do |format|
        if resource.valid?
          resource.send_confirmation_instructions
          redirect_to pm_users_path, :notice => 'Land Manager created successfully.' and return
        end
      end
    end
  end

  member_action :promote_to_project_manager, method: :put do
    resource.update_attributes!(user_type: User.user_types['project_manager'])
    redirect_to pm_users_path, :notice => 'User Promoted to Project Manager successfully.' and return
  end

end