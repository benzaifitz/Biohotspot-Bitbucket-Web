module Api
  module V1
    class NotificationsController < ApiController
      before_action :authenticate_user!
      before_action :set_reported_rating, only: [:show]

      # GET /api/v1/notifications.json
      api :GET, '/notifications.json', 'Returns a list of notifications recieved by the current user.'
      param :user_id, String, desc: 'Returns notifications where the user_id is the recipient.'
      def index
        @notifications = Rpush::Apns::Notification.includes(:user, :sender).where(user_id: current_user).where.not(device_token: nil)
      end

      # DELETE /api/v1/notifications/1
      # DELETE /api/v1/notifications/1.json
      api :DELETE, '/notifications/:id.json', 'Delete the notification.'
      param :id, String, desc: 'Id of the job which is to be deleted.', required: true
      def destroy
        @notification = Rpush::Apns::Notification.where(id: params[:id], user: current_user).first
        if !@notification.blank?
          @notification.destroy
          render json: {success: 'Notification deleted successfully.'}
        else
          render json: {error: 'Notification cannot be deleted.'}, status: :unprocessable_entity
        end
      end
    end
  end
end
