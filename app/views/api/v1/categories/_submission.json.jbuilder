json.extract! submission, :id, :survey_number, :submitted_by, :latitude, :longitude, :sub_category_id, :rainfall, :humidity,
              :temperature, :health_score, :live_leaf_cover, :live_branch_stem, :stem_diameter,
              :sample_photo, :monitoring_photo,:dieback, :leaf_tie_month, :seed_borer,
              :address, :status,
              :loopers, :grazing, :field_notes, :created_at, :updated_at
# json.monitoring_photo submission.monitoring_photo.file.url rescue nil
# json.sample_photo submission.sample_photo.file.url rescue nil
# json.additional_photos Photo.where(imageable_id: submission.id, imageable_type: 'Submission') do |photo|
#   json.photo photo.file.url rescue nil
# end

json.monitoring_image submission.monitoring_image.file.url rescue nil
json.sample_image submission.sample_image.file.url rescue nil
# json.additional_images Photo.where(imageable_id: @submission.id, imageable_type: 'Submission', imageable_sub_type: Photo::ADDITIONAL_IMAGES) do |photo|
#   json.url photo.url rescue nil
# end
json.additional_images do
  json.array! (Photo.where(imageable_id: submission.id, imageable_type: 'Submission', imageable_sub_type: Photo::ADDITIONAL_IMAGES).map(&:url) + [''])
end