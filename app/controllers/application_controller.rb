class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_active_admin_user!
    authenticate_user!
    redirect_to root_path unless current_user.admin?
  end

  def after_sign_in_path_for(resource)
    resource.admin? ? admin_root_path :  root_path
  end

end
