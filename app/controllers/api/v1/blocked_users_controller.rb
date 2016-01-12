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
      # param :id, Integer, desc: 'ID of blocked user to be shown.', required: false
      def show
      end

      # POST /api/v1/blocked_users.json
      api :POST, '/blocked_users.json', 'Create single record of blocked user.'
      param :user_id, Integer, desc: 'ID of users who is to be blocked.', required: false
      def create
        @blocked_user = BlockedUser.new(blocked_user_params.merge(blocked_by: current_user))
        begin
          @blocked_user.save
          render :show
        rescue *RecoverableExceptions => e
          error(E_INTERNAL, @blocked_user.errors.full_messages[0])
        end
      end

      api :DELETE, '/un_blocked_user.json', 'Un blocks the user.'
      param :user_id, Integer, desc: 'ID of user who is to be un blocked.', required: false
      def destroy
        @blocked_user = BlockedUser.where(blocked_user_params.merge(blocked_by: current_user))
        @blocked_user.destroy_all
        render json: BlockedUser.new
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_blocked_user
        @blocked_user = BlockedUser.where(id: params[:id], blocked_by_id: current_user.id).first
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def blocked_user_params
        params.require(:blocked_user).permit([:user_id])
      end

    end
  end
end
