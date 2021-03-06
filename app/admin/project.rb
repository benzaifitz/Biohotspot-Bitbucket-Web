ActiveAdmin.register Project do

  menu label: 'Projects', priority: 1, parent: 'Project Design'

  permit_params do
    allowed = [:title, :image, :image_cache, :ecosystem, :summary, :tags, :organization, :status, project_manager_projects_attributes: [:id, :project_manager_id, :is_admin, :_destroy, :_edit], category_ids:[], categories_attributes: [:id,:_update,:_create]]
    allowed.uniq
  end

  actions :all

  index do
    selectable_column
    id_column
    column :image do |p|
      image_tag(p.image.url(:thumb)) rescue nil
    end
    column :title, label: "Project Title"
    column :ecosystem
    column :summary do |p|
      omision = "<a href='#' onclick=\"$.fancybox('#{p.summary}')\"> View More</a>"
      p.summary.length > 100 ? (p.summary[0..100] + omision).html_safe : p.summary
    end
    column :tags do |p|
      omision = "<a href='#' onclick=\"$.fancybox('#{p.tags}')\"> View More</a>"
      p.tags.length > 100 ? (p.tags[0..100] + omision).html_safe : p.tags
    end
    column "Number of users" do |p|
      p.users.count
    end
    column :organization
    column :locations do |p|
      table(:style => 'margin-bottom: 0') do
        p.locations.each do |loc|
          tr do
            td(:style =>'border: 0; padding: 2px;') do
              link_to(loc.name.titleize, admin_location_path(loc))
            end
          end
        end
      end
    end
    # column :project_managers do |p|
    #   table(:style => 'margin-bottom: 0') do
    #     p.project_managers.each do |pm|
    #       tr do
    #         td(:style =>'border: 0; padding: 2px;') do
    #           link_to(pm.email, admin_user_path(pm))
    #         end
    #       end
    #     end
    #   end
    # end
    # column :admins do |p|
    #   admins = p.project_manager_projects.where(is_admin: true).map(&:project_manager_id)
    #   table(:style => 'margin-bottom: 0') do
    #     ProjectManager.where(id: admins).each do |pa|
    #       tr do
    #         td(:style =>'border: 0; padding: 2px;') do
    #           link_to(pa.email, admin_user_path(pa))
    #         end
    #       end
    #     end
    #   end
    # end
    column :created_at
    actions do |p|
      (item 'Open', change_project_status_admin_project_path(p), class: 'member_link', method: :put) if p.closed?
      (item 'Close', change_project_status_admin_project_path(p), class: 'member_link', method: :put) if p.open?
      (item 'Invite', invite_admin_project_path(p), class: 'fancybox member_link', style: 'padding-left: 5px', data: { 'fancybox-type' => 'ajax' })
    end
  end

  form do |f|
    # f.inputs 'Project Details', for: [:project_manager, f.object.project_manager || ProjectManager.new] do |f|
    if params[:project_manager_blank] == ''
      f.object.errors[:project_manager_id] = 'field is required'
    end
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Project Details' do
      f.inputs :multipart => true do
        f.input :image, :as => :file, input_html: {style: f.object.image.present? ? 'color: transparent':''}, :hint => f.object.image.present? \
                        ? image_tag(f.object.image.url(:thumb))
        : content_tag(:span, 'no image selected')
        f.input :image_cache, :as => :hidden
      end
      f.input :title
      f.input :ecosystem
      f.input :summary, input_html: {rows: 4}
      f.input :tags, input_html: {rows: 3}
      f.input :organization
      f.input :status
      f.inputs do
        f.has_many :project_manager_projects, heading: 'Project Managers', new_record: "Add new Project Manager", allow_destroy: true do |pmp|
          pmp.input :project_manager_id, as: :select, collection: ProjectManager.all.map{|pm| ["#{pm.email}", pm.id]}
          pmp.input :is_admin,as: :boolean
        end
      end
      # f.input :categories, as: :check_boxes, collection: Category.order(:name).all.map{|cat| [cat.name, cat.id]}.unshift(['All*', '']), label: 'Species', input_html: {class: 'project_category_checkbox'}
      f.input :categories, as: :select, :multiple => true, collection: Category.order(:species_scientific).all.map{|cat| [cat.species_scientific, cat.id]}.unshift(['All*', '']), label: 'Species', input_html: {class: 'project_category_checkbox'}
    end
    f.actions
  end


  member_action :change_project_status, method: :put do
    begin
      if resource.closed?
        resource.update_attributes({status: 'open'})
        flash[:notice] = 'Project opened'
      elsif resource.open?
        resource.update_attributes({status: 'closed'})
        flash[:notice] = 'Project closed'
      end
    rescue
      flash[:alert] = resource.errors.full_messages.to_sentence
    end
    redirect_to admin_projects_path
  end

  member_action :invite_user, method: :post do
    entered_emails = params[:emails].to_s.html_safe
    project_id = params[:id]
    emails = entered_emails.split(',')
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

    emails.each do |email|
      email = email.strip
      unless (email =~ VALID_EMAIL_REGEX).nil?
        user = User.find_by_email(email)
        unless user
          password = SecureRandom.hex(10)
          user = User.new(email: email, password: password, password_confirmation: password, pm_invited: true)
          user.save
        end
        if user && ProjectManagerProject.where(project_id: project_id, project_manager_id: user.id).count == 0
          project_invitation_token = SecureRandom.hex(10)
          pmp = ProjectManagerProject.create(project_id: project_id, project_manager_id: user.id, is_admin: params[:is_admin] == '1' ? true : false, token: project_invitation_token, status: 2)
          NotificationMailer.invite_user(pmp, current_user.username).deliver
        end
      end
    end
    redirect_to admin_projects_path, :notice => 'Users have been invited' and return
  end

  member_action :re_invite_user, method: :post do
    pmp_id = params[:id]
    pmp = ProjectManagerProject.find_by_id(pmp_id)
    NotificationMailer.invite_user(pmp, current_user.username).deliver if pmp
    redirect_to admin_project_users_path, :notice => 'User has been invited' and return
  end

  member_action :remove_user, method: :post do
    notice = 'User can\'t be removed'
    pmp_id = params[:id]
    pmp = ProjectManagerProject.find_by_id(pmp_id)
    if pmp
      all_pmp = ProjectManagerProject.where(project_id: pmp.project_id, is_admin: true, status: 'accepted').pluck(:id)
      all_pmp.delete(pmp.id)
      if all_pmp.length > 0
        pmp.destroy
        notice = 'User has been removed'
      end
    end

    redirect_to admin_project_users_path, :notice => notice and return
  end

  member_action :invite, method: :get do
    render template: 'admin/projects/invite', layout: false
  end

  preserve_default_filters!
  remove_filter :document_projects
  remove_filter :project_manager_projects
  remove_filter :project_categories
  remove_filter :feedbacks
  remove_filter :updated_at
  remove_filter :submissions
  remove_filter :project_requests
  remove_filter :image

  filter :status, as: :select, collection: -> {Project.statuses}
  filter :tags, filters: [:equals, :starts_with]
  # remove_filter :sub_categories
  show do
    attributes_table do
      row :id
      row :image do |p|
        image_tag(p.image.url(:thumb)) rescue nil
      end
      row :title
      row :ecosystem
      row :summary
      row :tags
      row :organization
      row :status
      row :project_managers do |p|
        table(:style => 'margin-bottom: 0') do
          p.project_managers.each do |pm|
            tr do
              td(:style =>'border: 0; padding: 2px;') do
                link_to(pm.email, admin_user_path(pm))
              end
            end
          end
        end
      end
      row :admins do |p|
        admins = p.project_manager_projects.where(is_admin: true).map(&:project_manager_id)
        table(:style => 'margin-bottom: 0') do
          ProjectManager.where(id: admins).each do |pa|
            tr do
              td(:style =>'border: 0; padding: 2px;') do
                link_to(pa.email, admin_user_path(pa))
              end
            end
          end
        end
      end
      row :updated_at
      row :created_at
    end
  end
end