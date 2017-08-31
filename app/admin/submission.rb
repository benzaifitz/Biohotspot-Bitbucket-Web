ActiveAdmin.register Submission do

  menu label: 'Submissions List', parent: 'Submissions', priority: 1

  permit_params :sub_category_id, :survey_number, :submitted_by, :lat, :long, :sub_category, :rainfall, :humidity, :temperature,
                :health_score, :live_leaf_cover, :live_branch_stem, :stem_diameter, :sample_photo, :monitoring_photo, :dieback,
                :leaf_tie_month, :seed_borer, :loopers, :grazing, :field_notes,
                photos_attributes: [ :id, :file, :url, :imageable_id, :imageable_type, :_destroy ]
  actions :all

  index do
    selectable_column
    id_column
    column :stem_diameter
    column :health_score
    column :live_leaf_cover
    column :live_branch_stem
    column :dieback
    column :temperature
    column :rainfall
    column :humidity
    column :leaf_tie_month
    column :seed_borer
    column :loopers
    column :grazing
    column :field_notes
    column :survey_number
    column :submitted_by
    column :lat
    column :long
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :sample_photo, as: :file
      f.input :monitoring_photo, as: :file
      f.has_many :photos, heading: 'Additional Photos', allow_destroy: true do |pm|
        pm.input :file, as: :file
        pm.input :url
      end
      f.input :stem_diameter, label: 'Stem diameter (trunk)'
      f.input :health_score, :input_html => { :type => "number" }
      f.input :live_leaf_cover, :input_html => { :type => "number" }
      f.input :live_branch_stem, :input_html => { :type => "number" }
      f.input :dieback, :input_html => { :type => "number" }
      f.input :temperature, label: 'Temperature (ave for previous month)'
      f.input :rainfall
      f.input :humidity, label: 'Temperature (ave for previous month)'
      f.inputs "IS THE FOLLOWING ON THE PLANT?"  do
        f.input :leaf_tie_month, as: :boolean
        f.input :seed_borer, as: :boolean
        f.input :loopers, as: :boolean
        f.input :grazing, as: :boolean
      end
      f.input :field_notes
      f.input :sub_category, input_html: { class: 'sub_category'}
      # f.input :survey_number
      f.input :submitted_by, :as => :select, :collection => LandManager.all.collect {|lm| [lm.full_name, lm.id] }
      # f.input :lat
      # f.input :long
      actions
    end
  end

  show do |submission|
    attributes_table do
      row :id
      row :sample_photo do |a|
        image_tag a.try(:sample_photo).try(:url), class: 'image_width' if a.sample_photo.url.present?
      end
      row :monitoring_photo do |a|
        image_tag a.try(:monitoring_photo).try(:url), class: 'image_width'  if a.monitoring_photo.url.present?
      end
      row "Additional Photos" do
        ul do
          submission.photos.each do |photo|
            li do
              image_tag photo.try(:file).try(:url), class: 'image_width'
            end
          end
        end
      end
      row :stem_diameter
      row :health_score
      row :live_leaf_cover
      row :live_branch_stem
      row :dieback
      row :temperature
      row :rainfall
      row :humidity
      row :leaf_tie_month
      row :seed_borer
      row :loopers
      row :grazing
      row :field_notes
      row :survey_number
      row :submitted_by
      row :lat
      row :long
      row :created_at
      row :updated_at

    end
  end


end