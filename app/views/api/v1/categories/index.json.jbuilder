json.deprecated_eula deprecated_eula
json.categories @categories do |category|
  json.partial! "api/v1/categories/category", category: category
end
