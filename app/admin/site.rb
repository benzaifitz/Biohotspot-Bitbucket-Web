ActiveAdmin.register Site do

  menu label: 'Sites List', parent: 'Sites', priority: 1

  permit_params do
    allowed = [:title, :summary, :tags, :project_id]
    allowed.uniq
  end

  actions :all

  index do
    selectable_column
    id_column
    column :title, label: "Project Title"
    column :summary, label: "Project Summary"
    column :tags
    column :categories do |s|
      table(:style => 'margin-bottom: 0') do
        s.categories.each do |sc|
          tr do
            td(:style =>'border: 0; padding: 2px;') do
              link_to(sc.name.titleize, admin_category_path(sc))
            end
          end
        end
      end
    end
    #TODO needs to implement this column after establishing surveys association.
    column :surveys do |p|
      "--"
    end
    column :created_at
    column :updated_at
    actions
  end

end