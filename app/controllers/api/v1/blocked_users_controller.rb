module Api
  module V1
    class BlockedUsersController < ApiController
      before_action :authenticate_user!

      # GET /api/v1/blocked_users.json
      def index
        @blocked_users = BlockedUser.where(blocked_by: current_user)
      end

    end
  end
end
