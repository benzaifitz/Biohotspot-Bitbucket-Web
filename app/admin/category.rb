ActiveAdmin.register Category do

  menu label: 'Categories List', parent: 'Categories', priority: 1

    permit_params :name, :description, :tags, :class_name, :family, :location, :url, :site_id,
                  photos_attributes: [ :id, :file, :url, :imageable_id, :imageable_type, :_destroy ]

  actions :all

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Administrator Details' do
      f.input :site_id, as: :select, collection: Site.all.map{|a| [a.title, a.id]}
      f.input :name
      f.input :description
      f.input :tags
      f.input :class_name
      f.input :family
      f.input :location
      f.input :url
      f.input :deleted_at,:as => :string, :input_html => {:class => 'datepicker hasDatePicker'}
      f.inputs "Photos"  do
        f.has_many :photos, allow_destroy: true do |pm|
          pm.input :file, as: :file
          pm.input :url
        end
      end
    end
    f.actions do
      f.action(:submit)
      f.cancel_link(admin_users_path)
    end
  end

  show do |category|
    attributes_table do
      row :id
      row :name
      row :description
      row :tags
      row :class_name
      row :family
      row :location
      row :url
      row :site_id
      row :created_at
      row :updated_at
      row :deleted_at
      row "Images" do
        ul do
          category.photos.each_with_index do |photo,index|
            li do
              link_to "photo_#{index+1}", "#{request.host_with_port}#{photo.try(:file).try(:url)}"
              # image_tag(photo.file.url)
            end
          end
        end
      end
    end
  end

end