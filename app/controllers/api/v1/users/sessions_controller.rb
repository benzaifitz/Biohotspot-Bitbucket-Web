module Api
  module V1
    module Users
      class SessionsController < DeviseTokenAuth::SessionsController

        def create
          # @resource will have been set by set_user_by_token concern
          user = User.find_by(email: params[:email])
          user_by_mobile = User.find_by(mobile_number: params[:email]) if params[:email].length > 0
          if user && user.active?
            super
          elsif user_by_mobile && user_by_mobile.active? && user_by_mobile.land_manager?
            params[:email] = user_by_mobile.email
            super
          else
            render_error_banned_user
          end
        end

        private

        def render_error_banned_user
          render json: {
              success: false,
              errors: [I18n.t("devise_token_auth.sessions.disabled_account")]
          }, status: :forbidden
        end
      end
    end
  end
end