ActiveAdmin.register Submission do

  menu label: 'Submissions List', parent: 'Submissions', priority: 1

  permit_params :sub_category_id, :survey_number, :submitted_by, :lat, :long, :sub_category, :rainfall, :humidity, :temperature,
               :health_score, :live_leaf_cover, :live_branch_stem, :stem_diameter,
               photos_attributes: [ :id, :file, :url, :imageable_id, :imageable_type, :_destroy ]
  actions :all

  index do
    selectable_column
    id_column
    column :survey_number
    column :submitted_by
    column :lat
    column :long
    column :rainfall
    column :humidity
    column :temperature
    column :health_score
    column :live_leaf_cover
    column :live_branch_stem
    column :stem_diameter
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :sub_category
      f.input :survey_number
      f.input :submitted_by, :as => :select, :collection => LandManager.all.collect {|lm| [lm.full_name, lm.id] }
      # f.input :submitted_by
      f.input :lat
      f.input :long
      f.input :rainfall
      f.input :humidity
      f.input :temperature
      f.input :health_score
      f.input :live_leaf_cover
      f.input :live_branch_stem
      f.input :stem_diameter
      f.inputs "Photos"  do
        f.has_many :photos, allow_destroy: true do |pm|
          pm.input :file, as: :file
          pm.input :url
        end
      end
      actions
    end
  end

  show do |submission|
    attributes_table do
      row :id
      row :survey_number
      row :submitted_by
      row :lat
      row :long
      row :rainfall
      row :humidity
      row :temperature
      row :health_score
      row :live_leaf_cover
      row :live_branch_stem
      row :stem_diameter
      row :created_at
      row :updated_at
      row "Images" do
        ul do
          submission.photos.each_with_index do |photo,index|
            li do
              link_to "photo_#{index+1}", "#{request.host_with_port}#{photo.try(:file).try(:url)}"
            end
          end
        end
      end
    end
  end


end