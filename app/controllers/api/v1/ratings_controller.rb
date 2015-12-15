module Api
  module V1
    class RatingsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_rating, only: [:show, :edit, :update, :destroy]

      # GET /api/v1/ratings
      # GET /api/v1/ratings.json
      def index
        @ratings = Rating.all
      end

      # GET /api/v1/ratings/1
      # GET /api/v1/ratings/1.json
      def show
      end

      # GET /api/v1/ratings/new
      def new
        @rating = Rating.new
      end

      # GET /api/v1/ratings/1/edit
      def edit
      end

      # POST /api/v1/ratings
      # POST /api/v1/ratings.json
      def create
        @rating = Rating.new(rating_params.merge(user_id: current_user))
        if @rating.save
          render :show
        else
          render json: @rating.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/ratings/1
      # PATCH/PUT /api/v1/ratings/1.json
      def update
        respond_to do |format|
          if @rating.update(rating_params)
            format.html { redirect_to @rating, notice: 'Rating was successfully updated.' }
            format.json { render :show, status: :ok, location: @rating }
          else
            format.html { render :edit }
            format.json { render json: @rating.errors, status: :unprocessable_entity }
          end
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
        permitted_params = [:rating, :comment, :rated_on_id]
        params.require(:rating).permit(permitted_params)
      end
    end
  end
end

