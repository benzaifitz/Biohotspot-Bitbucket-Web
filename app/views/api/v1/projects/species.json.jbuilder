json.categories @species do |category|
  json.partial! "api/v1/categories/category", category: category
end
json.eula_id  current_user.eula_id