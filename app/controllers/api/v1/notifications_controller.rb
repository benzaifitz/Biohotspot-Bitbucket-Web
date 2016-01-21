module Api
  module V1
    class NotificationsController < ApiController
      before_action :authenticate_user!
      before_action :check_user_eula_and_privacy
      before_action :set_reported_rating, only: [:show]

      # GET /api/v1/notifications.json
      api :GET, '/notifications.json', 'Returns a list of push notifications recieved by the current user.'
      param :timestamp, String, desc: 'Timestamp of the first or last record in the cache. timestamp and direction are to be used in conjunction'
      param :direction, String, desc: 'Direction of records. up: 0 and down: 1, with up all records updated after the timestamp are returned, and with down 20 records updated before the timestamp will be returned'
      def index
        @notifications = Rpush::Client::ActiveRecord::Notification.includes(:user, :sender).where(user: current_user)
                          .where.not(device_token: nil).paginate_with_timestamp(params[:timestamp], params[:direction])
      end

      # DELETE /api/v1/notifications/1
      # DELETE /api/v1/notifications/1.json
      api :DELETE, '/notifications/:id.json', 'Delete the notification.'
      param :id, String, desc: 'Id of the job which is to be deleted.', required: true
      def destroy
        Rpush::Apns::Notification.where(id: params[:id], user: current_user).delete_all
        render json: {success: 'Notification deleted successfully.'}
      end
    end
  end
end
