ActiveAdmin.register Submission, as: "Image Submission" do

  menu label: 'Image Submissions List', parent: 'Submissions', priority: 2

  permit_params do
    allowed = [:sub_category_id, :survey_number, :submitted_by, :lat, :long, :sub_category, :rainfall, :humidity, :temperature,
               :health_score, :live_leaf_cover, :live_branch_stem, :stem_diameter]
    allowed.uniq
  end

  actions :all

  index do
    selectable_column
    id_column
    column :surver_number
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

      actions
    end
  end

end