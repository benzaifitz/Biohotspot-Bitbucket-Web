module Api
  module V1
    class NotificationsController < ApiController
      before_action :authenticate_user!

      # GET /api/v1/notifications.json
      api :GET, '/notifications.json', 'Returns a list of push notifications recieved by the current user.'
      param :page, String, desc: 'Value should be 1 or greater'
      def index
        offset = params[:page].blank? ? 0 : (params[:page].to_i * 10)
        @notifications = Rpush::Client::ActiveRecord::Notification.includes(:user, :sender).
            where(user_id: current_user.id, deleted: false)
            .limit(Api::V1::LIMIT).offset(offset)
      end

      # DELETE /api/v1/notifications/1
      # DELETE /api/v1/notifications/1.json
      api :DELETE, '/notifications/:id.json', 'Delete the notification.'
      param :id, String, desc: 'Id of the job which is to be deleted.', required: true
      def destroy
        Rpush::Client::ActiveRecord::Notification.where(id: params[:id], user: current_user).delete_all
        render json: {success: 'Notification deleted successfully.'}
      end

      # DELETE /api/v1/notifications.json
      api :DELETE, '/notifications.json', 'Delete all the notifications of current user.'
      def destroy_all
        Rpush::Client::ActiveRecord::Notification.where(user: current_user).update_all(deleted: true)
        render json: {success: 'All Notifications deleted successfully.'}
      end
    end
  end
end
