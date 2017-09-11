if @submission.present?
  json.extract! @submission, :id, :survey_number, :submitted_by, :lat, :long, :sub_category_id, :rainfall, :humidity,
                :temperature, :health_score, :live_leaf_cover, :live_branch_stem, :stem_diameter,
                :sample_photo_url, :sample_photo_thumb_url, :monitoring_photo_thumb_url, :monitoring_photo_url,
                :dieback, :leaf_tie_month, :seed_borer, :loopers, :grazing, :field_notes, :created_at, :updated_at

  json.additional_photos Photo.where(imageable_id: @submission.id, imageable_type: 'Submission') do |photo|
    json.extract! photo, :id, :file_url, :file_thumb_url
  end
end
