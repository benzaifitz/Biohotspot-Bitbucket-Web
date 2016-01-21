module Api
  module V1
    module Users
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        before_filter :configure_permitted_parameters

        protected

        def configure_permitted_parameters
          devise_parameter_sanitizer.for(:sign_up).push(:username, :first_name, :last_name, :company, :eula_id, :privacy_id, :user_type, :device_token, :device_type)
        end
      end
    end
  end
end


