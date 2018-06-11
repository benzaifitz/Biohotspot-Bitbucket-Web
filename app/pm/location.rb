ActiveAdmin.register Location, namespace: :pm do

  menu label: 'Locations', priority: 2

  permit_params do
    allowed = [:name, :project_id, :description]
    allowed.uniq
  end

  actions :all

  index do
    selectable_column
    id_column
    column :name
    column :project
    column :sites do |p|
      table(:style => 'margin-bottom: 0') do
        p.sites.each do |ps|
          tr do
            td(:style =>'border: 0; padding: 2px;') do
              link_to(ps.title.titleize, admin_site_path(ps))
            end
          end
        end
      end
    end
    column :created_at
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Location Details' do
      f.input :name
      f.input :description
      f.input :project_id, as: :select, collection: current_project_manager.managed_projects.all.map{|p| [p.title, p.id]}
    end
    f.actions
  end
  show do
    attributes_table :id, :name, :description, :updated_at, :created_at
  end

  filter :name

end