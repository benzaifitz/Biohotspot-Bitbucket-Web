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

      rescue_from Exception do |e|
        error(E_API, "An internal API error occured. Please try again.\n #{e.message}")
      end

      def error(code = E_INTERNAL, message = 'API Error')
        render json: {
                   status: STATUS_ERROR,
                   error_no: code,
                   message: message
               }, :status=>500
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
    end
  end
end

