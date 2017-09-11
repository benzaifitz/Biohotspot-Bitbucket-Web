ActiveAdmin.register Category do

  menu label: 'Categories List', parent: 'Categories', priority: 1

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
    actions
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Administrator Details' do
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
      f.action(:submit)
      f.cancel_link(admin_categories_path)
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

end