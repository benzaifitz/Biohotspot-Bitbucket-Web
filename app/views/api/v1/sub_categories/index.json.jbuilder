if @sub_categories.present?
  json.sub_categories @sub_categories do |sub_category|
    json.extract! sub_category, :id, :name, :category_id, :user_id
    json.submission do
      json.partial! "api/v1/sub_categories/submission", submission: sub_category.submission
    end
  end
end
