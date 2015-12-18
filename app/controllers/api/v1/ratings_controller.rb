module Api
  module V1
    class RatingsController < ApiController
      before_action :authenticate_user!
      before_action :set_rating, only: [:show, :edit, :update, :destroy]

      # GET /api/v1/ratings
      # GET /api/v1/ratings.json
      def index
        @ratings = Rating.all
      end

      # GET /api/v1/ratings/1.json
      api :GET, '/ratings/:id.json', 'Returns rating info for given ID.'
      param :id, Integer, desc: 'ID of the rating.', required: true
      def show
      end

      # GET /api/v1/ratings/new
      def new
        @rating = Rating.new
      end

      # GET /api/v1/ratings/1/edit
      def edit
      end

      # POST /api/v1/ratings.json
      api :POST, '/ratings.json', 'Create a new rating.'
      param :rating, Float, desc: 'Rating value between 1 and 5.', required: false
      param :comment, String, desc: 'Comment.', required: false
      param :rated_on_id, Integer, desc: 'Id of user for which rating is provided.', required: false
      def create
        @rating = Rating.new(rating_params.merge(user_id: current_user))
        if @rating.save
          render :show
        else
          render json: @rating.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/ratings/1.json
      api :PUT, '/ratings/:id.json', 'Sets new status for Rating.'
      param :status, Integer, desc: 'Possible values 0 (active), 1 (reported), 2 (censored), 3 (allowed)', required: true
      def update
        if @rating.update(rating_params)
          render :show
        else
          render json: @rating.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/ratings/1
      # DELETE /api/v1/ratings/1.json
      def destroy
        @rating.destroy
        respond_to do |format|
          format.html { redirect_to ratings_url, notice: 'Rating was successfully destroyed.' }
          format.json { head :no_content }
        end
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_rating
        @rating = Rating.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def rating_params
        permitted_params = [:rating, :comment, :rated_on_id, :status]
        params.require(:rating).permit(permitted_params)
      end
    end
  end
end

