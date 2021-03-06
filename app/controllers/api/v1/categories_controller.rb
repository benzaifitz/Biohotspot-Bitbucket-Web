module Api
  module V1
    class CategoriesController < ApiController
      before_action :authenticate_user!
      before_action :set_category, only: [:show, :destroy, :update]

      api :GET, '/categories.json', 'Return all categories'
      def index
        # @categories = current_user.locations.map(&:sites).flatten.map(&:categories).flatten rescue []
        # category_ids = current_user.locations.map(&:sites).flatten.map(&:sub_categories).flatten.map(&:categories).flatten.map(&:id).uniq rescue []
        @query = ""
        @query << "categories.tags ILIKE '%#{params[:q]}%'" if params[:q].present?
        # @categories = current_user.locations.first.project.categories.where(query) rescue Category.where(query)
        @specie_types = get_grouped_categories
      end

      # def current_user
      #   User.find(88)
      # end

      api :GET, '/categories/:id.json', 'Return single category'
      def show
        if @category.present?
          render json: @category.as_json.merge(project: (@category.site.project rescue nil), site: @category.site,:photos => @category.photos.map{|a| {uri: a.file.url}},
                                               submissions: @category.sub_categories.map{|a| a.submission})
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
    
      def get_grouped_categories
        category_types = []
        SpecieType.joins(:categories).where(@query).order("name asc").uniq.each do |st|
          categories = st.categories.where(@query).order("name asc").group_by { |d| d[:family_common] }
          categories.each do |family, categories_group|
            type_hash = {
              type: [st.name, family].join(", "),
              categories: []
            }
            categories_group.each do |category|
              type_hash[:categories] << category
            end
            category_types << type_hash
          end
        end
        category_types
      end
    
      private

      def set_category
        @category = Category.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def category_params
        params.require(:category).permit([:name, :description, :tags, :class_name, :family, :location, :url, :site_id])
      end

      def deprecated_eula
        latest_eula = Eula.find_by_is_latest(true)
        latest_eula.id != current_user.eula_id
      end
    end
  end
end

