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

      def convert_data_to_upload(obj_hash)
        if obj_hash[:image_data]
          image_data_string = obj_hash[:image_data]
          image_data_binary = Base64.decode64(image_data_string)

          temp_img_file = Tempfile.new("")
          temp_img_file.binmode
          temp_img_file << image_data_binary
          temp_img_file.rewind

          img_params = {:filename => "#{obj_hash[:image_name]}.#{obj_hash[:image_extension]}", :type => obj_hash[:image_type], :tempfile => temp_img_file}
          uploaded_file = ActionDispatch::Http::UploadedFile.new(img_params)

          obj_hash[:profile_picture] = uploaded_file
          [:image_data, :image_name, :image_extension, :image_type].each {|attr| obj_hash.delete(attr)}
        end
        return obj_hash
      end

    end
  end
end

