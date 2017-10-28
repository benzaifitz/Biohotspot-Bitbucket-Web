ActiveAdmin.register SubCategory, as: 'Sample' do

  menu label: 'Samples', priority: 3

  permit_params do
    [:name, :site_id, category_ids: []]
  end

  actions :all

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Sample Details' do
      f.input :name
      # f.input :category_id, label: 'Species', as: :select, collection: Category.all.map{|a| [a.name, a.id]}
      f.input :site, as: :select, collection: Site.all.map{|s| [s.project_location_prefix_name, s.id]}
      f.input :categories, label: 'Species', as: :select, multiple: true, :collection => Category.all.map{ |s|  [s.name, s.id] }
      # f.input :user_id, label: 'Land Manager', as: :select, collection: User.project_manager.all.map{|a| [a.email, a.id]}
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
    column :name
    column :site
    column 'Species' do |sc|
      categories = ''
      sc.categories.each do |s|
        categories += "#{link_to(s.name, admin_species_path(s.id), target: '_blank')},"
      end
      categories.html_safe
    end
    # column 'Land Manager',:user_id do |category|
    #   link_to category.user.email, admin_user_path(category.user_id) if category.user.present?
    # end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :site
      # row 'Species' do |c|
      #   link_to c.category.name, admin_species_path(c.category)
      # end
      row 'Species' do |sc|
        categories = ''
        sc.categories.each do |s|
          categories += "#{link_to(s.name, admin_species_path(s.id), target: '_blank')}<br>"
        end
        categories.html_safe
      end
      # row :user_id do
      #   link_to category.user.email, admin_user_path(category.user_id) if category.user.present?
      # end
      row :created_at
      row :updated_at
    end
  end

  action_item :only => :show do
    link_to("New Sample", new_admin_sample_path)
  end


  filter :category_id, label: 'Species', as: :select, collection: -> {Category.all.map{|c| [c.name, c.id]}}
  filter :name
  filter :created_at
end