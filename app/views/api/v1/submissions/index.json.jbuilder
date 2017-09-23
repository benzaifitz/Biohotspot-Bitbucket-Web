if @submissions.present?
  json.submissions @submissions do |submission|
    json.extract! submission, :id, :survey_number, :submitted_by, :latitude, :longitude, :sub_category_id, :rainfall, :humidity,
                  :temperature, :health_score, :live_leaf_cover, :live_branch_stem, :stem_diameter,
                  :sample_photo, :monitoring_photo,:dieback, :leaf_tie_month, :seed_borer,
                  :address,
                  :loopers, :grazing, :field_notes, :created_at, :updated_at
    json.monitoring_photo submission.monitoring_photo.serializable_hash rescue nil
    json.sample_photo submission.sample_photo.serializable_hash rescue nil
    json.additional_photos Photo.where(imageable_id: submission.id, imageable_type: 'Submission') do |photo|
      json.photo photo.file.serializable_hash rescue nil
    end
  end
end