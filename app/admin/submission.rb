ActiveAdmin.register Submission do

  menu label: 'Submissions List', parent: 'Submissions', priority: 1

  permit_params do
    allowed = [:survey_number, :submitted_by, :lat, :long, :sub_category, :rainfall, :humidity, :temperature,
               :health_score, :live_leaf_cover, :live_branch_stem, :stem_diameter]
    allowed.uniq
  end

  actions :all

  # index do
  #   selectable_column
  #   id_column
  #   column :title, label: "Project Title"
  #   column :summary, label: "Project Summary"
  #   column :tags
  #   #TODO needs to implement this column after establishing surveys association.
  #   column :surveys do |p|
  #     "--"
  #   end
  #   column :created_at
  #   column :updated_at
  #   actions
  # end

end