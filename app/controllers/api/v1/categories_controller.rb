module Api
  module V1
    class CategoriesController < ApiController
      before_action :authenticate_user!
      before_action :set_category, only: [:show, :destroy, :update]

      api :GET, '/categories.json', 'Return all categories'
      def index
        @categories = Category.all
        render json: @categories.map{|a| {id: a.id, name: a.name, location: a.location,
                                          surveys: a.sub_categories.map{|a| a.submissions.count}.sum,
                                          complete_surveys: a.sub_categories.map{|a| a.submissions.where(status: Submission.statuses[:complete]).count}.sum,
                                          photo: a.photos.present? ? a.photos.first.file_url : ""}}, status: :ok
      end

      api :GET, '/categories/:id.json', 'Return single category'
      def show
        if @category.present?
          render json: @category.as_json.merge(site: @category.site,:photos => @category.photos.map{|a| {uri: a.file.url}},
                                               submissions: @category.sub_categories.map{|a| a.submissions})
        end
      end

      api :POST, '/categories.json', 'Create a category'
      param :name, String, desc: 'name of category who is to be created.', required: false
      param :description, String, desc: 'description of category who is to be created.', required: false
      param :tags, String, desc: 'tags of category who is to be created.', required: false
      param :class_name, String, desc: 'class_name of category who is to be created.', required: false
      param :family, String, desc: 'family of category who is to be created.', required: false
      param :location, String, desc: 'location of category who is to be created.', required: false
      param :url, String, desc: 'url of category who is to be created.', required: false
      param :site_id, Integer, required: false
      def create
        @category = Category.new(category_params)
        begin
          @category.save!
          render :show
        rescue *RecoverableExceptions => e
          error(E_INTERNAL, @category.errors.full_messages[0])
        end
      end

      api :PUT, '/categories/:id.json', 'Update a category'
      param :name, String, desc: 'name of category who is to be updated.', required: false
      param :description, String, desc: 'description of category who is to be updated.', required: false
      param :tags, String, desc: 'tags of category who is to be updated.', required: false
      param :class_name, String, desc: 'class_name of category who is to be updated.', required: false
      param :family, String, desc: 'family of category who is to be updated.', required: false
      param :location, String, desc: 'location of category who is to be updated.', required: false
      param :url, String, desc: 'url of category who is to be updated.', required: false
      def update
        if !@category.blank? && @category.update(category_params)
          render :show
        else
          render json: {error: 'Category not found.'}, status: :unprocessable_entity
        end
      end

      api :DELETE, '/categories/:id.json', 'Delete single category'
      def destroy
        @category.destroy
        render json: {success: true, status: 200}
      end

      private

      def set_category
        @category = Category.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def category_params
        params.require(:category).permit([:name, :description, :tags, :class_name, :family, :location, :url, :site_id])
      end
    end
  end
end

