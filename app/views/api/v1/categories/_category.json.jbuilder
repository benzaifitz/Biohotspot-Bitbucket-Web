json.category category, "id", "name","photographer", "description", "tags", "class_name", "family_common", "location", "url", "site_id", "created_at", "updated_at", "deleted_at", "family_scientific", "species_scientific", "species_common", "status", "growth", "habit", "impact", "distribution"
json.extract! category, "id", "name", "location"
json.photos category.photos do |photo|
  json.uri photo.file_url
end
site_ids = current_project.locations.map(&:site_ids).flatten.uniq rescue []
allowed_sub_cats = [SubCategory.new(name: SubCategory::UNKNOWN_SAMPLE)] + category.sub_categories.where(site_id: site_ids).to_a
json.project current_project.id rescue nil
json.site category.site rescue nil
json.location Location.new rescue nil
json.surveys allowed_sub_cats.count rescue nil
json.complete_surveys allowed_sub_cats.map{|a| 1 if Submission.submission_status(a,category) == 'submitted'}.compact.sum
json.photo category.photos.present? ? category.photos.first.file_url : ""
json.sub_categories allowed_sub_cats do |sub_category|
  json.extract! sub_category, :id, :name, :user_id
  json.last_submission_status Submission.submission_status(sub_category,category)
  json.project_id sub_category.site.location.project.id rescue category.site.location.project.id rescue nil
  json.site_id sub_category.site.id rescue category.site.id rescue nil
  json.site_name sub_category.site_title
  json.category_id category.id rescue nil
  json.location_id sub_category.site.location.id rescue category.site.location.id rescue nil
  json.submission do
    json.partial! "api/v1/categories/submission", submission: Submission.new
  end
end
