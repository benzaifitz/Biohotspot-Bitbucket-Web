json.deprecated_eula Eula.find_by_is_latest(true).id != current_user.eula_id
json.categories @categories do |category|
  json.partial! "api/v1/categories/category", category: category
end
