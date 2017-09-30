module Api
  module V1
    class ApiController < ApplicationController
      include DeviseTokenAuth::Concerns::SetUserByToken
      protect_from_forgery with: :null_session

      RecoverableExceptions = [
          ActiveRecord::RecordNotUnique,
          ActiveRecord::RecordInvalid,
          ActiveRecord::RecordNotSaved
      ]

      # rescue_from Exception do |e|
      #   error(E_API, "An internal API error occured. Please try again.\n #{e.message}")
      # end

      # def error(code = E_INTERNAL, message = 'API Error')
      #   render json: {
      #              status: STATUS_ERROR,
      #              error_no: code,
      #              message: message
      #          }, :status=>406
      # end

      def error(code = E_INTERNAL, message = 'API Error', status = 406)
        render json: {
                   status: STATUS_ERROR,
                   error_no: code,
                   message: message,
                   errors: {
                       message: message,
                       full_messages: [message]
                   }
               }, status: status
      end

      def validate_json
        begin
          JSON.parse(request.raw_post).deep_symbolize_keys
        rescue JSON::ParserError
          error E_INVALID_JSON, 'Invalid JSON received'
          return
        end
      end

      # @param object - a Hash or an ActiveRecord instance
      def success(object = {})
        object = JSON.parse(object.to_json) unless object.instance_of?(Hash)
        render json: { status: STATUS_OK }.merge(object)
      end

      def check_user_eula_and_privacy
        #TODO incorporate caching
        latest_eula = Eula.find_by_is_latest(true)
        # latest_privacy = Privacy.find_by_is_latest(true)
        if current_user.id == 33 && latest_eula.id != current_user.eula_id
          render json: { deprecated_eula: latest_eula.id != current_user.eula_id}, status: '419' and return
        end
      end
    end
  end
end

