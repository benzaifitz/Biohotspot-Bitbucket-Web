json.deprecated_eula Eula.find_by_is_latest(true).id != current_user.eula_id
json.category_types @specie_types do |st|
  json.type st[:type]
  json.categories st[:categories] do |category|
    json.partial! "api/v1/categories/category", category: category, current_project: @project
  end
end