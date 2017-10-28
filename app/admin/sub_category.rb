ActiveAdmin.register SubCategory, as: 'Sample' do

  menu label: 'Samples', priority: 3

  permit_params do
    [:name, :site_id, category_ids: []]
  end

  actions :all

  # config.clear_action_items!
  #
  # action_item :only => [:index, :show] do
  #   link_to "Manual Entry" , new_admin_sample_path
  # end
  #
  # action_item :only => :show do
  #   link_to "Edit Sample" , edit_admin_sample_path(resource.id)
  # end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Sample Details' do
      f.input :name, label: 'Label'
      f.input :site, as: :select, collection: Site.all.map{|s| [s.project_location_prefix_name, s.id]}
      f.input :categories, label: 'Species', as: :select, multiple: true, :collection => Category.all.map{ |s|  [s.name, s.id] }
    end
    f.actions do
      if f.object.new_record?
        f.action(:submit, as: :button, label: 'Create Sample' )
      else
        f.action(:submit, as: :button, label: 'Update Sample' )
      end
      f.cancel_link(collection_path)
    end
  end

  index do
    selectable_column
    id_column
    column 'Label', :name
    column :site
    column 'Species' do |sc|
      categories = ''
      sc.categories.each do |s|
        categories += "#{link_to(s.name, admin_species_path(s.id), target: '_blank')},"
      end
      categories.html_safe
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row 'Label' do |sc|
        sc.name
      end
      row :site
      row 'Species' do |sc|
        categories = ''
        sc.categories.each do |s|
          categories += "#{link_to(s.name, admin_species_path(s.id), target: '_blank')}<br>"
        end
        categories.html_safe
      end
      row :created_at
    end
  end

  action_item :only => :show do
    link_to("New Sample", new_admin_sample_path)
  end


  filter :category_id, label: 'Species', as: :select, collection: -> {Category.all.map{|c| [c.name, c.id]}}
  filter :name, label: 'Label'
  filter :created_at
end