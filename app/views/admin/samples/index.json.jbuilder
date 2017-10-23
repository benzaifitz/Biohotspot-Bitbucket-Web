json.sub_categories @samples do |sub_category|
  json.extract! sub_category, :id, :name, :user_id
  json.species sub_category.category rescue nil
end
