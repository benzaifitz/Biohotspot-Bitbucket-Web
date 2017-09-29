module Api
  module V1
    class SubCategoriesController < ApiController
      before_action :authenticate_user!


      api :GET, '/sub_categories.json', 'Return all sub categories'
      def index
        @sub_categories = Submission.where.not(sub_category_id: nil).map(&:sub_category).flatten
      end


    end
  end
end

