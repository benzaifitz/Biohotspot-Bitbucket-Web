module Api
  module V1
    class ReportedRatingsController < ApiController
      before_action :authenticate_user!
      before_action :set_reported_rating, only: [:show, :edit, :update, :destroy]

      # GET /api/v1/reported_ratings
      # GET /api/v1/reported_ratings.json
      def index
        @reported_ratings = ReportedRating.all
      end

      # GET /api/v1/reported_ratings/1
      # GET /api/v1/reported_ratings/1.json
      def show
      end

      # GET /api/v1/reported_ratings/new
      def new
        @reported_rating = ReportedRating.new
      end

      # GET /api/v1/reported_ratings/1/edit
      def edit
      end

      # POST /api/v1/reported_ratings.json
      def create
        @reported_rating = ReportedRating.new(reported_rating_params.merge(reported_by: current_user))
        if @reported_rating.save
          render :show
        else
          render json: @reported_rating.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/reported_ratings/1
      # PATCH/PUT /api/v1/reported_ratings/1.json
      def update
        respond_to do |format|
          if @reported_rating.update(reported_rating_params)
            format.html { redirect_to @reported_rating, notice: 'Reported rating was successfully updated.' }
            format.json { render :show, status: :ok, location: @reported_rating }
          else
            format.html { render :edit }
            format.json { render json: @reported_rating.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /api/v1/reported_ratings/1
      # DELETE /api/v1/reported_ratings/1.json
      def destroy
        @reported_rating.destroy
        respond_to do |format|
          format.html { redirect_to reported_ratings_url, notice: 'Reported rating was successfully destroyed.' }
          format.json { head :no_content }
        end
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
