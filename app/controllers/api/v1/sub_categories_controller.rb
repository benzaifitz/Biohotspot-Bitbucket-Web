module Api
  module V1
    class SubCategoriesController < ApiController
      before_action :authenticate_user!


      api :GET, '/sub_categories.json', 'Return all sub categories'
      def index
        sub_categories_ids = Submission.where.not(sub_category_id: nil).
            where(submitted_by: current_user.id).
            map(&:sub_category_id).flatten.compact
        @category = Category.find(params[:id])
        sub_categories_ids = sub_categories_ids + @category.sub_categories.map{|sc| sc.id if sc.submission.blank?}
        @sub_categories = @category.sub_categories.where(id: sub_categories_ids.uniq)
      end


    end
  end
end

