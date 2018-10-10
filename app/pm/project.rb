ActiveAdmin.register Project, namespace: :pm do

  menu label: 'Projects', priority: 1

  permit_params do
    allowed = [:title, :summary, :tags, :client_name, :status, project_manager_projects_attributes: [:id, :project_manager_id, :is_admin, :_destroy, :_edit]]
    allowed.uniq
  end

  actions :all

  index do
    selectable_column
    id_column
    column :title, label: "Project Title"
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
    column :client_name
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
    column :created_at
    actions do |p|
      (item 'Open', change_project_status_pm_project_path(p), class: 'member_link', method: :put) if p.closed?
      (item 'Close', change_project_status_pm_project_path(p), class: 'member_link', method: :put) if p.open?
    end
  end

  form do |f|
    # f.inputs 'Project Details', for: [:project_manager, f.object.project_manager || ProjectManager.new] do |f|
    if params[:project_manager_blank] == ''
      f.object.errors[:project_manager_id] = 'field is required'
    end
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Project Details' do
      f.input :title
      f.input :summary, input_html: {rows: 4}
      f.input :tags, input_html: {rows: 3}
      f.input :client_name
      f.input :status
      f.inputs do
        f.has_many :project_manager_projects, heading: 'Project Managers', new_record: "Add new Project Manager", allow_destroy: true do |pmp|
          pmp.input :project_manager_id, as: :select, collection: ProjectManager.all.map{|pm| ["#{pm.email}", pm.id]}
          pmp.input :is_admin,as: :boolean
        end
      end
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
    redirect_to pm_projects_path
  end

  # before_build do |record|
  #   record.project_manager = current_project_manager
  # end

  filter :locations, as: :select, collection: proc{current_project_manager.locations.pluck(:name, :id)}
  filter :status, as: :select, collection: -> {Project.statuses}
  preserve_default_filters!
  remove_filter :document_projects
  remove_filter :users
  remove_filter :documents
  remove_filter :project_manager
  remove_filter :project_manager_projects
  remove_filter :project_categories
  remove_filter :categories
  remove_filter :feedbacks
  remove_filter :updated_at
  # remove_filter :sub_categories
  show do
    attributes_table do
      row :id
      row :title
      row :summary
      row :tags
      row :client_name
      row :status
      row :project_managers do |p|
        table(:style => 'margin-bottom: 0') do
          p.project_managers.each do |pm|
            tr do
              td(:style =>'border: 0; padding: 2px;') do
                link_to(pm.email, pm_user_path(pm))
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
                link_to(pa.email, pm_user_path(pa))
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