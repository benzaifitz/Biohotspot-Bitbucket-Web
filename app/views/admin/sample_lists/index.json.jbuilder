if @sample_lists.present?
  json.submissions @sample_lists do |submission|
    json.extract! submission, :id, :survey_number, :submitted_by, :latitude, :longitude, :rainfall, :humidity,
                  :temperature, :health_score, :live_leaf_cover, :live_branch_stem, :stem_diameter,
                  :sample_photo, :monitoring_photo,:dieback, :leaf_tie_month, :seed_borer,
                  :address, :status,
                  :loopers, :grazing, :field_notes, :created_at, :updated_at
    json.sample submission.sub_category rescue nil
    json.monitoring_image submission.monitoring_image.url rescue nil
    json.sample_image submission.sample_image.url rescue nil
    json.additional_images do
      json.array! (Photo.where(imageable_id: submission.id, imageable_type: 'Submission', imageable_sub_type: Photo::ADDITIONAL_IMAGES).map(&:url) + [''])
    end
  end
end