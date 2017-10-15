json.deprecated_eula false
json.categories @categories do |category|
  json.partial! "api/v1/categories/category", category: category
end
