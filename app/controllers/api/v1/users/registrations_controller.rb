module Api
  module V1
    module Users
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        before_action :configure_permitted_parameters

        def create
          params[:user_type] = User.user_types[:land_manager]
          super
        end

        protected

        def configure_permitted_parameters
          devise_parameter_sanitizer.permit(:sign_up, keys:[:mobile_number, :project_id, :username, :first_name,
                                                            :last_name, :company, :eula_id, :privacy_id,
                                                            :user_type, :device_token, :device_type])
        end

      end
    end
  end
end


