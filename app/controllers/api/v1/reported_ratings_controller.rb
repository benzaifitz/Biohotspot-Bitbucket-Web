module Api
  module V1
    class ReportedRatingsController < ApiController
      before_action :authenticate_user!
      before_action :set_reported_rating, only: [:show]

      # GET /api/v1/reported_ratings/1.json
      api :GET, '/reported_ratings/:id.json', 'Returns reported ratings info for given ID.'
      # param :id, Integer, desc: 'ID of the reported rating.', required: true
      def show
      end

      # POST /api/v1/reported_ratings.json
      api :POST, '/reported_ratings.json', 'Create a new reported rating.'
      # param :rating_id, Float, desc: 'Id of rating which is being reported.', required: true
      def create
        @reported_rating = ReportedRating.new(reported_rating_params.merge(reported_by: current_user))
        begin
          @reported_rating.save!
          render :show
        rescue *RecoverableExceptions => e
          error(E_INTERNAL, @reported_rating.errors.full_messages[0])
        end
        # if @reported_rating.save
        #   render :show
        # else
        #   render json: @reported_rating.errors, status: :unprocessable_entity
        # end
      end


      private
      # Use callbacks to share common setup or constraints between actions.
      def set_reported_rating
        @reported_rating = ReportedRating.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def reported_rating_params
        permitted_params = [:rating_id]
        params.require(:reported_rating).permit(permitted_params)
      end
    end
  end
end
