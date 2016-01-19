class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead
  #protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :log_user_sign_out, if: -> { request.url.include?'/sign_out' }

  def authenticate_active_admin_user!
    authenticate_user!
    unless current_user.administrator?
      sign_out current_user
      redirect_to root_path and return
    end
  end

  def after_sign_in_path_for(resource)
    resource.administrator? ? admin_root_path :  root_path
  end

  def log_user_sign_out
    # set current_sign_in_at to nil to indicate user is not logged in
    return if current_user.nil?
    current_user.current_sign_in_at = nil
    current_user.save
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:username, :first_name, :last_name, :company, :eula_id, :privacy_id, :user_type, :device_token, :device_type)
  end
end
