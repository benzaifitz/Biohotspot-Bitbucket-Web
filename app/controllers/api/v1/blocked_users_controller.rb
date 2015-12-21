module Api
  module V1
    class BlockedUsersController < ApiController
      before_action :authenticate_user!
      before_action :set_blocked_user, only: [:show]


      # GET /api/v1/blocked_users.json
      api :GET, '/blocked_users.json', 'Get all the users who are blocked by current user.'
      def index
        @blocked_users = BlockedUser.where(blocked_by: current_user)
      end

      # GET /api/v1/customers/1.json
      api :GET, '/blocked_users/:id.json', 'Returns user_id and blocked_by_id'
      # param :id, Integer, desc: 'ID of blocked user to be shown.', required: true
      def show
      end

      # POST /api/v1/blocked_users.json
      api :POST, '/blocked_users.json', 'Create single record of blocked user.'
      # param :user_id, Integer, desc: 'ID of users who is to be blocked.', required: true
      def create
        @blocked_user = BlockedUser.new(blocked_user_params.merge(blocked_by: current_user))
        if @blocked_user.save
          render :show
        else
          render json: @blocked_user.errors, status: :unprocessable_entity
        end
      end

      api :DELETE, '/un_blocked_user.json', 'Un blocks the user.'
      # param :user_id, Integer, desc: 'ID of user who is to be un blocked.', required: true
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
