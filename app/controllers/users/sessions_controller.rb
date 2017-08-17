class Users::SessionsController < Devise::SessionsController

  layout 'active_admin_logged_out'

  @@json_hash = {
      success: false,
      status: 'error'
  }

  # GET /resource/sign_in
  def new
    super
  end
  # POST /resource/sign_in
  def create
    user = User.find_by(email: params[:user][:email]||params[:username]) rescue nil
    (user && user.approved) ? super : render_error_unapproved_user
  end

  private
  def render_error_unapproved_user
    message = I18n.t("devise_token_auth.sessions.unapproved_account")
    render json: @@json_hash.merge(errors: {banned_user: message}.merge(full_messages: [message])), status: :forbidden
  end
end
