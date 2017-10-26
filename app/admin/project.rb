ActiveAdmin.register Project do

  menu label: 'Projects', priority: 1

  permit_params do
    allowed = [:title, :summary, :tags, :client_name, :project_manager_id]
    allowed.uniq
  end

  actions :all

  index do
    selectable_column
    id_column
    column :title, label: "Project Title"
    column :summary, label: "Project Summary"
    column :tags
    column "Number of users" do |p|
      p.users.count
    end
    column :client_name
    column :location
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    # f.inputs 'Project Details', for: [:project_manager, f.object.project_manager || ProjectManager.new] do |f|
    if params[:project_manager_blank] == ''
      f.object.errors[:project_manager_id] = 'field is required'
    end
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Project Details' do
      f.input :title
      f.input :summary
      f.input :tags
      f.input :client_name
      f.input :project_manager_id, as: :select, collection: options_for_select(ProjectManager.all.map{|pm| [pm.email, pm.id]}, f.object.project_manager ? f.object.project_manager.id : '')
      f.actions
    end
  end

  controller do
    def update(options={}, &block)
      # You can put your send email code over here
      begin
        raise 'Project manager is required' if params[:project][:project_manager_id].blank?
        project_manager = ProjectManager.find(params[:project].delete(:project_manager_id))
        Project.transaction do
          resource.assign_attributes(title: params[:project][:title], summary: params[:project][:summary], tags: params[:project][:tags], client_name: params[:project][:client_name])
          project_manager.managed_project = resource
          project_manager.save!
          resource.save!
          flash[:notice] = "Project updated successfully."
          redirect_to admin_projects_path
        end
      rescue => e
        flash[:error] = e.is_a?(String) ? e : e.message
        redirect_to edit_admin_project_path(resource)
      end
    end
    def new
      @project = Project.new
      @project.build_project_manager
    end
    def create
      begin
        @project = Project.new(permitted_params[:project])
        raise 'Project manager is required' if params[:project][:project_manager_id].blank?
        @project_manager = ProjectManager.find(params[:project][:project_manager_id])
        Project.transaction do
          @project.save!
          @project_manager.managed_project = @project
          @project_manager.save!
          flash[:notice] = "Project created successfully."
          redirect_to admin_projects_path
        end
      rescue => e
        flash[:error] = e.is_a?(String) ? e : e.message
        redirect_to edit_admin_project_path(resource)
      end
    end
  end

  preserve_default_filters!
  remove_filter :document_projects
  remove_filter :feedbacks
  # remove_filter :sub_categories

end