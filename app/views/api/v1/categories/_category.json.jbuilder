json.category category, "id", "name", "description", "tags", "class_name", "family_common", "url", "created_at", "updated_at", "deleted_at", "family_scientific", "species_scientific", "species_common", "status", "growth", "habit", "impact", "distribution"
json.extract! category, "id", "name"
json.photos category.photos do |photo|
  json.uri photo.file_url
end
site = category.current_user_site(current_user)
json.project site.location.project rescue nil
json.location site.location rescue nil
json.site site rescue nil
json.surveys category.sub_categories.map{|a| a.submission}.compact.count rescue nil
json.complete_surveys category.sub_categories.map{|a| 1 if a.submission && a.submission.approved?}.compact.sum
json.photo category.photos.present? ? category.photos.first.file_url : ""
json.sub_categories category.sub_categories do |sub_category|
  json.extract! sub_category, :id, :name, :category_id, :user_id
  json.last_submission_status Submission.where(sub_category_id: sub_category.id).last.status rescue nil
  json.submission do
    json.partial! "api/v1/categories/submission", submission: Submission.new
  end
end
