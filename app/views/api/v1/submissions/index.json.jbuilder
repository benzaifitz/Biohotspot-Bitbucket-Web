if @submissions.present?
  json.submissions @submissions do |submission|
    json.extract! @submission, :id, :survey_number, :submitted_by, :lat, :long, :sub_category_id, :rainfall, :humidity, :temperature, :health_score, :live_leaf_cover, :live_branch_stem, :stem_diameter,
                  :sample_photo, :monitoring_photo,:dieback, :leaf_tie_month, :seed_borer, :loopers, :grazing, :field_notes, :created_at, :updated_at

  end
end