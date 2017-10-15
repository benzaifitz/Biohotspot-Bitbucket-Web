json.extract! category, "id", "name", "description", "tags", "class_name", "family_common", "location", "url", "site_id", "created_at", "updated_at", "deleted_at", "family_scientific", "species_scientific", "species_common", "status", "growth", "habit", "impact", "distribution"
json.photos category.photos do |photo|
  json.uri photo.file_url
end
json.surveys category.sub_categories.map{|a| a.submission}.compact.count rescue nil
json.complete_surveys category.sub_categories.map{|a| 1 if a.submission && a.submission.complete?}.compact.sum
json.photo category.photos.present? ? category.photos.first.file_url : ""
json.sub_categories category.current_user_sub_catrgories(22) do |sub_category|
  json.extract! sub_category, :id, :name, :category_id, :user_id
  json.submission do
    json.partial! "api/v1/categories/submission", submission: (sub_category.submission || Submission.new)
  end
end
