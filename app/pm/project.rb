ActiveAdmin.register Project, namespace: :pm do

  menu label: 'Projects', priority: 1

  permit_params do
    allowed = [:title, :summary, :tags, :client_name]
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
      f.input :summary, input_html: {rows: 4}
      f.input :tags, input_html: {rows: 3}
      f.input :client_name
      # f.input :project_manager_id, as: :select, collection: options_for_select(ProjectManager.all.map{|pm| [pm.email, pm.id]}, f.object.project_manager ? f.object.project_manager.id : '')
    end
    f.actions
  end

  before_build do |record|
    record.project_manager = current_project_manager
  end

  filter :locations, as: :select, collection: proc{current_project_manager.locations.pluck(:name, :id)}
  preserve_default_filters!
  remove_filter :document_projects
  remove_filter :users
  remove_filter :documents
  remove_filter :project_manager
  remove_filter :project_categories
  remove_filter :categories
  remove_filter :feedbacks
  remove_filter :updated_at
  # remove_filter :sub_categories
  show do
    attributes_table :id, :title, :summary, :tags, :client_name, :project_manager, :updated_at, :created_at
  end
end