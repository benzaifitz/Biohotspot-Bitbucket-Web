module Api
  module V1
    class RatingsController < ApiController
      before_action :authenticate_user!
      before_action :set_rating, only: [:show, :update]

      # GET /api/v1/ratings/1.json
      api :GET, '/ratings/:id.json', 'Returns rating info for given ID.'
      # param :id, Integer, desc: 'ID of the rating.', required: true
      def show
      end

      # POST /api/v1/ratings.json
      api :POST, '/ratings.json', 'Create a new rating.'
      # param :rating, String, desc: 'Rating value between 0.0 and 5.0', required: false
      param :comment, String, desc: 'Comment.', required: false
      param :rated_on_id, Integer, desc: 'Id of user for which rating is provided. An additional param rating is also to be sent in range 0.0 to 5.0', required: false
      def create
        @rating = Rating.new(rating_params.merge(user_id: current_user.id))
        begin
          @rating.save!
          render :show
        rescue *RecoverableExceptions => e
          error(E_INTERNAL, @rating.errors.full_messages[0])
        end
        # if @rating.save
        #   render :show
        # else
        #   render json: @rating.errors, status: :unprocessable_entity
        # end
      end

      # PATCH/PUT /api/v1/ratings/1.json
      api :PUT, '/ratings/:id.json', 'Sets new status for Rating.'
      param :status, String, desc: 'Possible values 0 (active), 1 (reported), 2 (censored), 3 (allowed)', required: false
      def update
        begin
          @rating.update(rating_params)
          render :show
        rescue *RecoverableExceptions => e
          error(E_INTERNAL, @rating.errors.full_messages[0])
        end
        # if @rating.update(rating_params)
        #   render :show
        # else
        #   render json: @rating.errors, status: :unprocessable_entity
        # end
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

