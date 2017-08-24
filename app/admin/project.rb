ActiveAdmin.register Project do

  menu label: 'Projects List', parent: 'Projects', priority: 1

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
    column "Number_of_users" do |p|
      p.users.count
    end
    column :client_name
    #TODO needs to implement this column after establishing sites association.
    column :sites do |p|
      "--"
    end
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
      # if params[:action] != "neaw"
      #   f.inputs do
      #     f.has_many :project_manager, heading: 'Project Manager', new_record: true do |pm|
      #       # pm.select ProjectManager.all
      #       pm.input :id, as: :select, collection: ProjectManager.all.map{|pm| [pm.email, pm.id]}
      #     end
      # end
      # end
      # f.has_one :project_manager
      # f.input :project_manager
      # f.inputs do
      #   f.has_many :project_manager, heading: 'Project Manager', allow_destroy: true, new_record: false do |a|
      #     a.input :email
      #   end
      # end
      f.actions
    end
  end

  controller do
    def update(options={}, &block)
      # You can put your send email code over here
      begin
        raise 'pm' if params[:project][:project_manager_id].blank?
        resource.project_manager = ProjectManager.find(params[:project].delete(:project_manager_id)) if params[:project] && params[:project][:project_manager_id]
        resource.assign_attributes(title: params[:project][:title], summary: params[:project][:summary], tags: params[:project][:tags], client: params[:project][:client])
        resource.save!
        redirect_to admin_projects_path
      rescue => e
        redirect_to edit_admin_project_path(project_manager_blank: (e.to_s == 'pm' ? '': 'no pm issue'))
      end
    end
    def new
      @project = Project.new
      @project.build_project_manager
    end
    def create
      begin
        @project = Project.new(permitted_params[:project])
        raise 'pm' if params[:project][:project_manager_id].blank?
        @project_manager = ProjectManager.find(params[:project][:project_manager_id])
        Project.transaction do
          @project.save!
          @project_manager.managed_project = @project
          @project_manager.save!
          redirect_to admin_projects_path
        end
      rescue => e
        redirect_to new_admin_project_path(project_manager_blank: (e.to_s == 'pm' ? '': 'no pm issue'))
      end
    end
  end

end