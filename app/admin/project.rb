ActiveAdmin.register Project do

  menu label: 'Projects List', parent: 'Projects', priority: 1

  permit_params do
    allowed = [:title, :summary, :tags, :client_name, :project_manager_id, project_manager_attributes: [:id]]
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
    f.inputs 'Project Details' do
      f.input :title
      f.input :summary
      f.input :tags
      f.input :client_name
      f.inputs do
        f.has_many :project_manager, heading: 'Project Manager', new_record: true do |pm|
          # pm.select ProjectManager.all
          pm.input :id, as: :select, collection: ProjectManager.all.map{|pm| [pm.email, pm.id]}
        end
      end
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
      resource.project_manager = ProjectManager.find(params[:project].delete(:project_manager_attributes)[:id]) if params[:project] && params[:project][:project_manager_attributes][:id]
      resource.assign_attributes(title: params[:project][:title], summary: params[:project][:summary], tags: params[:project][:tags])
      resource.save!
      redirect_to admin_projects_path
    end
  end

end