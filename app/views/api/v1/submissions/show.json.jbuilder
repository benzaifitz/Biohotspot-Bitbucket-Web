if @submission.present?
  json.extract! @submission, :id, :survey_number, :submitted_by, :latitude, :longitude, :sub_category_id, :rainfall, :humidity,
                :temperature, :health_score, :live_leaf_cover, :live_branch_stem, :stem_diameter, :address, :status,
                :dieback, :leaf_tie_month, :seed_borer, :loopers, :grazing, :field_notes, :created_at, :updated_at
  json.monitoring_photo @submission.monitoring_image.serializable_hash rescue nil
  json.sample_photo @submission.sample_image.serializable_hash rescue nil
  json.additional_photos @submission.photos do |photo|
    json.photo photo.file.serializable_hash rescue nil
  end
end
