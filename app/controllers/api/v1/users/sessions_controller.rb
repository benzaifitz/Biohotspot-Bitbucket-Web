module Api
  module V1
    module Users
      class SessionsController < DeviseTokenAuth::SessionsController

        def create
          # @resource will have been set by set_user_by_token concern
          user = User.find_by(email: params[:email])
          user_by_mobile = User.find_by(mobile_number: params[:email]) if params[:email].length > 0
          if user && user.administrator?
            render_error_banned_user(user)
          elsif user && user.active_for_authentication?
            user.device_token = params[:device_token]
            user.device_type = params[:device_type]
            super
          elsif user_by_mobile && user_by_mobile.active?
            params[:email] = user_by_mobile.email
            super
          else
            render_error_banned_user(user)
          end
        end

        private

        def render_error_banned_user(user)
          message = if user && user.banned?
                      [I18n.t("devise_token_auth.sessions.disabled_account")]
                    elsif user && !user.confirmed?
                      [I18n.t("devise.failure.unconfirmed")]
                    elsif user && !user.approved?
                      [I18n.t("devise_token_auth.sessions.unapproved_account")]
                    elsif user.administrator?
                      [I18n.t("devise_token_auth.sessions.disable_admin_on_app")]
                    elsif user
                      [I18n.t("devise_token_auth.sessions.bad_credentials")]
                    else
                      [I18n.t("devise_token_auth.sessions.user_not_found")]
                    end
          render json: {
              success: false,
              message: message,
              errors: {
                  message: message,
                  full_messages: [message]
              }
          }, status: :forbidden
        end

        def render_create_success
          @resource.update_columns(device_token: params[:device_token], device_type: params[:device_type])
          render "api/v1/users/success"
        end
      end
    end
  end
end