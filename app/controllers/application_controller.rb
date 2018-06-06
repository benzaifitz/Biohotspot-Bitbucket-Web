class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead

  prepend_before_action :print_headers,if: :json_request?
  before_action :log_user_sign_out, if: -> { request.url.include?'/sign_out' }
  protect_from_forgery only: :null_session, prepend: true

  def print_headers
    puts 'token headers token headers token headers token headers token headers'
    puts 'access-token',request.headers['access-token']
    puts 'client',request.headers['client']
    puts 'uid',request.headers['uid']
    puts 'token-type',request.headers['token-type']
    Rails.logger.info(request.headers['access-token'])
    Rails.logger.info(request.headers['client'])
    Rails.logger.info(request.headers['uid'])
    Rails.logger.info(request.headers['token-type'])
    Rails.logger.info(params)
  end

  def route_not_found
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end

  def authenticate_active_admin_user!
    authenticate_user!
    unless current_user.administrator?
      sign_out current_user
      redirect_to root_path and return
    end
  end

  def authenticate_active_admin_pm!
    authenticate_project_manager!
    unless current_project_manager
      Devise.sign_out_all_scopes ? sign_out : sign_out(current_project_manager)
      redirect_to root_path and return
    end
  end

  def after_sign_in_path_for(resource)
    if resource.administrator?
      admin_root_path
    elsif resource.project_manager?
      pm_root_path
    else
      root_path
    end
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

  def json_request?
    request.format.json?
  end

  def layout_by_resource
    if devise_controller? #&& resource_name == :user && action_name == "new"
      "active_admin_logged_out"
    else
      "application"
    end
  end
  def after_sign_out_path_for(resource)
    if resource == :project_manager
      new_project_manager_session_path
    else
      root_path
    end
  end
end
