ActiveAdmin.register Site, namespace: :pm do
  menu label: 'Sites List', parent: 'Sites', priority: 1

  permit_params do
    allowed = [:title, :summary, :tags, :project_id]
    allowed.uniq
  end

  actions :all, :except => [:destroy]

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
              sc.name.titleize
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