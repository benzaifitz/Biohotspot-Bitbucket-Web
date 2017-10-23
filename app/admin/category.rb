ActiveAdmin.register Category, as: 'Species' do

  menu label: 'Species', parent: 'Species', priority: 1

    permit_params :name, :description, :tags, :class_name, :family_scientific, :family_common, :species_scientific, :species_common, :status, :growth, :habit, :impact, :distribution, :location, :url, :site_id,
                  photos_attributes: [ :id, :file, :url, :imageable_id, :imageable_type, :_destroy ]

  actions :all

  index do
    selectable_column
    column :id
    column :name
    column :description
    column :tags
    column :class_name
    column :location
    column :url
    column :family_common
    column :family_scientific
    column :species_common
    column :species_scientific
    column :status
    column :growth
    column :habit
    column :impact
    column :distribution
    column :created_at
    column :updated_at
    actions do |c|
      link_to("Clone", clone_admin_species_path(id: c.id))
    end
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Species Details' do
      f.input :site_id, as: :select, collection: Site.all.map{|a| [a.title, a.id]}
      f.input :name
      f.input :description
      f.input :tags
      f.input :class_name
      f.input :family_scientific
      f.input :family_common
      f.input :species_scientific
      f.input :species_common
      f.input :status
      f.input :growth
      f.input :habit
      f.input :impact
      f.input :distribution
      f.input :location
      f.input :url
      f.inputs "Photos", :multipart => true  do
        f.has_many :photos, allow_destroy: true do |pm|
          pm.input :file, :as => :file, :hint => pm.object.file.present? \
                        ? image_tag(pm.object.file.url(:thumb))
                        : content_tag(:span, 'no image selected')

          pm.input :file_cache, :as => :hidden
        end
      end
    end
    f.actions do
      if f.object.new_record?
        f.action(:submit, as: :button, label: 'Create Species' )
      else
        f.action(:submit, as: :button, label: 'Update Species' )
      end
      f.cancel_link(collection_path)
    end
  end

  show do |category|
    attributes_table do
      row :id
      row :name
      row :description
      row :tags
      row :class_name
      row :family_scientific
      row :family_common
      row :species_scientific
      row :species_common
      row :status
      row :growth
      row :habit
      row :impact
      row :distribution
      row :location
      row :url
      row :site_id
      row :created_at
      row :updated_at
      row "Images" do
        images = ''
        category.photos.map(&:file).compact.each do |p|
          images += "#{link_to(image_tag(p.url(:thumb)), p.url, target: '_blank')}<br><br>"
        end
        images.html_safe
      end
    end
  end

  preserve_default_filters!
  remove_filter :deleted_at
  remove_filter :photos
  remove_filter :sub_categories

  member_action :clone, method: :get do
    @resource = resource.dup
    # @resource.photos = resource.photos.dup
    render :new, :layout => false
  end

  action_item :only => :show do
    link_to("Make a Copy", clone_admin_species_path(id: resource.id))
  end


end