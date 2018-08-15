ActiveAdmin.register ProjectManager, as: 'Project Manager' do

  menu false
  
  permit_params do
    allowed = []
    allowed.push :password if params[:project_manager] && !params[:project_manager][:password].blank?
    allowed += [:first_name, :last_name, :email, :company, :profile_picture, :profile_picture_cache,
                :username, :project_manager_id, managed_project_ids: []]
    allowed.uniq
  end

  actions :all, :except => [:index]

  form do |f|
    f.inputs 'Project Manager Details' do
      f.input :email
      f.input :password, input_html: {autocomplete: 'new-password'}
      f.input :username, hint: 'Allowed characters are A to Z, a to z, 0 to 9 and _(underscore)'
      # f.input :company
      f.input :first_name
      f.input :last_name

      #TODO use managed_project association
      # f.input :project
      f.input :managed_projects, multiple: true
      # f.inputs :managed_project do |proj|
      #   unless proj.blank?
      #     link_to proj.managed_project.name, admin_project_path(proj.managed_project)
      #   else
      #     ""
      #   end
      # end
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
        redirect_to admin_users_path, :notice => 'Project Manager updated successfully.' and return if resource.valid?
      end
    end

    def create
      super do |format|
        if resource.valid?
          resource.send_confirmation_instructions
          redirect_to admin_users_path, :notice => 'Project Manager created successfully.' and return
        end
      end
    end
  end

  # controller do
  #   def scoped_collection
  #     User.where(user_type: User.user_types[:project_manager])
  #   end
  # end
end