class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead

  before_action :log_user_sign_out, if: -> { request.url.include?'/sign_out' }
  protect_from_forgery only: :null_session, prepend: true

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
    current_user.device_token = nil
    current_user.device_type = nil
    current_user.save
  end

  protected

  def layout_by_resource
    if devise_controller? #&& resource_name == :user && action_name == "new"
      "active_admin_logged_out"
    else
      "application"
    end
  end
end
