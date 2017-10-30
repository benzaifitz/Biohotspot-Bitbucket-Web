ActiveAdmin.register Category, as: 'Species' do

  menu label: 'Species',priority: 5 #, parent: 'Species', priority: 1

    permit_params :crop_h, :crop_w, :crop_x, :crop_y, :name, :description, :tags, :class_name, :family_scientific,
                  :family_common, :species_scientific, :species_common, :status, :growth, :habit, :impact,
                  :distribution, :location, :url, project_ids: [],
                  photos_attributes: [ :id, :file, :url, :imageable_id, :imageable_type, :_destroy ]

  actions :all

  index do
    selectable_column
    column :id
    column :name
    column 'Projects' do |s|
      table(:style => 'margin-bottom: 0') do
        s.projects.each do |sc|
          tr do
            td(:style =>'border: 0; padding: 2px;') do
              link_to(sc.title.titleize, admin_project_path(sc))
            end
          end
        end
      end
    end


    column 'Samples' do |s|
      table(:style => 'margin-bottom: 0') do
        s.sub_categories.each do |sc|
          tr do
            td(:style =>'border: 0; padding: 2px;') do
              link_to(sc.name.titleize, admin_sample_path(sc))
            end
          end
        end
      end
    end

    column :description do |p|
      omision = "<a href='#' onclick=\"$.fancybox('#{p.description}')\"> View More</a>"
      p.description.length > 100 ? (p.description[0..100] + omision).html_safe : p.description
    end
    column :tags do |p|
      omision = "<a href='#' onclick=\"$.fancybox('#{p.tags}')\"> View More</a>"
      p.tags.length > 100 ? (p.tags[0..100] + omision).html_safe : p.tags
    end
    column :class_name
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
    actions do |c|
      link_to("Clone", clone_admin_species_path(id: c.id))
    end
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Species Details' do
      f.input :projects, as: :select, multiple: true, collection: Project.all.map{|a| [a.title, a.id]}
      # f.input :sites, as: :select, :collection => Site.all.map{ |s|  [s.title, s.id] }
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
      f.input :url
      f.inputs "Photos", :multipart => true  do
        f.has_many :photos, allow_destroy: true do |pm|
          pm.input :file, :as => :file, :hint => pm.object.file.present? \
                        ? image_tag(pm.object.file.url(:thumb))
                        : content_tag(:span, 'no image selected')

          pm.input :file_cache, :as => :hidden
          # for attribute in [:crop_x, :crop_y, :crop_w, :crop_h]
          #   pm.input attribute, :id => attribute, as: :hidden
          # end
          # insert_tag(Arbre::HTML::Li, class: 'file input optional') do
          #   insert_tag(Arbre::HTML::P, class: 'inline-hints') do
          #     insert_tag(Arbre::HTML::Img, id: 'category_photo_preview', src: "#{pm.object.file.url}?#{Random.rand(100)}")
          #   end
          # end
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
      row :description, input_html: {rows: 4}
      row :tags, input_html: {rows: 3}
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
      row :url
      row 'Projects' do |s|
        table(:style => 'margin-bottom: 0') do
          s.projects.each do |sc|
            tr do
              td(:style =>'border: 0; padding: 2px;') do
                link_to(sc.title.titleize, admin_project_path(sc))
              end
            end
          end
        end
      end
      # row :sites do |c|
      #   sites = ''
      #   c.sites.each do |s|
      #     sites += "#{link_to(s.title, admin_site_path(s.id), target: '_blank')}<br>"
      #   end
      #   sites.html_safe
      # end
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

  # preserve_default_filters!
  # remove_filter :deleted_at
  # remove_filter :updated_at
  # remove_filter :photos
  # remove_filter :sub_categories
  # remove_filter :category_sub_categories

  filter :name
  filter :site, multiple: true
  filter :sub_categories, label: 'Samples', multiple: true
  filter :description
  filter :tags
  filter :class_name
  filter :url
  filter :family_scientific
  filter :family_common
  filter :species_scientific
  filter :species_common
  filter :status
  filter :growth
  filter :habit
  filter :impact
  filter :distribution
  filter :created_at

  member_action :clone, method: :get do
    @resource = resource.dup
    # @resource.photos = resource.photos.dup
    render :new, :layout => false
  end

  action_item :only => :show do
    link_to("Make a Copy", clone_admin_species_path(id: resource.id))
  end


end