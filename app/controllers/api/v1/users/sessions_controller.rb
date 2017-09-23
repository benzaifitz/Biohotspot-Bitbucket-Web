module Api
  module V1
    module Users
      class SessionsController < DeviseTokenAuth::SessionsController

        def create
          # @resource will have been set by set_user_by_token concern
          user = User.find_by(email: params[:email])
          user_by_mobile = User.find_by(mobile_number: params[:email]) if params[:email].length > 0
          if user && user.active_for_authentication?
            super
          elsif user_by_mobile && user_by_mobile.active? && user_by_mobile.land_manager?
            params[:email] = user_by_mobile.email
            super
          else
            render_error_banned_user(user)
          end
        end

        private

        def render_error_banned_user(user)
          message = user.banned? ? [I18n.t("devise_token_auth.sessions.disabled_account")] : [I18n.t("devise_token_auth.sessions.unapproved_account")]
          render json: {
              success: false,
              errors: message
          }, status: :forbidden
        end

        def render_create_success
          render "api/v1/users/success"
        end
      end
    end
  end
end