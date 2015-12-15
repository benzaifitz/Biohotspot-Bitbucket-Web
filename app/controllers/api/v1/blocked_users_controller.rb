module Api
  module V1
    class BlockedUsersController < ApiController
      before_action :authenticate_user!
      before_action :set_blocked_user, only: [:show]


      # GET /api/v1/blocked_users.json
      def index
        @blocked_users = BlockedUser.where(blocked_by: current_user)
      end

      # GET /api/v1/customers/1.json
      def show
      end

      # POST /api/v1/blocked_users.json
      def create
        @blocked_user = BlockedUser.new(blocked_user_params.merge(blocked_by: current_user))
        if @blocked_user.save
          render :show
        else
          render json: @blocked_user.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/blocked_users/1.json
      def destroy
        @blocked_user = BlockedUser.where(blocked_user_params.merge(blocked_by: current_user))
        @blocked_user.destroy_all
        render json: BlockedUser.new
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_blocked_user
        @blocked_user = BlockedUser.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def blocked_user_params
        params.require(:blocked_user).permit([:user_id])
      end

    end
  end
end
