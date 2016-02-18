module Api
  module V1
    module Users
      class SessionsController < DeviseTokenAuth::SessionsController

        def create
          # @resource will have been set by set_user_by_token concern
          if User.find_by(email: params[:email]).active?
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