# Shared code for banning and enabling users
module SharedAdmin
  extend ActiveSupport::Concern

  def self.included(base)
    base.send(:member_action, :confirm_status_change, method: :get) do
      @user = resource.bannable
      @status_change_action = params[:status_change_action]
      render template: 'admin/users/confirm_status_change', layout: false
    end

    [:disable, :enable].each do |status_change_action|
      base.send(:member_action, status_change_action, method: :put) do
        resource.send("#{status_change_action.to_s}_with_comment" , params[:user][:status_change_comment])
        redirect_to send("admin_#{resource.class.name.pluralize.underscore}_path"), notice: status_change_action == :ban ? "User Banned!" : "User Enabled!"
      end
    end
  end
end