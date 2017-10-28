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
    end
    f.actions
  end



  preserve_default_filters!
  remove_filter :document_projects
  remove_filter :feedbacks
  # remove_filter :sub_categories

end