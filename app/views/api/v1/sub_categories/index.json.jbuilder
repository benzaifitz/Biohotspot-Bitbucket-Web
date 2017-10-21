if @category.present?
  json.category do
    json.partial! "api/v1/sub_categories/category", category: @category
  end
    json.sub_categories @sub_categories do |sub_category|
      json.extract! sub_category, :id, :name, :category_id, :user_id
      json.submission do
        json.partial! "api/v1/sub_categories/submission", submission: (sub_category.current_user_submission(current_user.id) || Submission.new)
      end
    end
end