ActiveAdmin.register Site, namespace: :pm do
  menu label: 'Sites', priority: 3, parent: 'Project Design'

  permit_params do
    allowed = [:location_id, :title, :summary, :tags, :project_id]
    allowed.uniq
  end

  actions :all

  index do
    selectable_column
    id_column
    column 'Name', :title
    column :summary do |p|
      omision = "<a href='#' onclick=\"$.fancybox('#{p.summary}')\"> View More</a>"
      p.summary.length > 100 ? (p.summary[0..100] + omision).html_safe : p.summary
    end
    column :tags do |p|
      omision = "<a href='#' onclick=\"$.fancybox('#{p.tags}')\"> View More</a>"
      p.tags.length > 100 ? (p.tags[0..100] + omision).html_safe : p.tags
    end
    column :location
    # column 'Species' do |s|
    #   table(:style => 'margin-bottom: 0') do
    #     s.categories.each do |sc|
    #       tr do
    #         td(:style =>'border: 0; padding: 2px;') do
    #           link_to(sc.name.titleize, admin_species_path(sc))
    #         end
    #       end
    #     end
    #   end
    # end
    #TODO needs to implement this column after establishing surveys association.
    column 'Samples' do |p|
      table(:style => 'margin-bottom: 0') do
        p.sub_categories.each do |sc|
          tr do
            td(:style =>'border: 0; padding: 2px;') do
              link_to(sc.project_location_site_prefix_name, pm_sample_path(sc.id)) rescue nil
            end
          end
        end
      end
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :summary
      row :tags
      row :location
      row :created_at
      row :updated_at
      row 'Samples' do |s|
        table(:style => 'margin-bottom: 0') do
          s.sub_categories.each do |sc|
            tr do
              td(:style =>'border: 0; padding: 2px;') do
                link_to(sc.project_location_site_prefix_name, pm_sample_path(sc.id)) rescue nil
              end
            end
          end
        end
      end
    end
  end
  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Site Details' do
      f.input :title, label: 'Name'
      f.input :summary, input_html: {rows: 4}
      f.input :tags, input_html: {rows: 3}
      # f.input :categories, label: 'Species', as: :select, multiple: true, :collection => Category.all.map{ |s|  [s.name, s.id] }
      f.input :location, as: :select, collection: current_project_manager.locations.all.map{|p| [p.name, p.id]}
      # f.input :sub_categories, label: 'Samples', as: :select, collection: SubCategory.all.map{|a| [a.name, a.id]}
    end
    f.actions do
      if f.object.new_record?
        f.action(:submit, as: :button, label: 'Create Site' )
      else
        f.action(:submit, as: :button, label: 'Update Site' )
      end
      f.cancel_link(collection_path)
    end
  end
  filter :location, as: :select,collection: proc{current_project_manager.locations.pluck(:name, :id)}
  filter :sub_categories, as: :select,collection: proc{current_project_manager.sub_categories.pluck(:name, :id)}
  # filter :users, as: :select, collection: proc{LandManager.joins(locations:[:project]).where("projects.id in (?)", current_project_manager.projects.pluck(:id)).pluck(:username, :id)}
  filter :title
  filter :summary
  filter :tags, filters: [:equals, :starts_with]
  filter :created_at
  filter :updated_at
end