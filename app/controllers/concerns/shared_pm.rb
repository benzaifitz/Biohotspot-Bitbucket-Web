# Shared code for banning and enabling users
module SharedPM
  extend ActiveSupport::Concern

  def self.included(base)
    base.send(:member_action, :confirm_status_change, method: :get) do
      @user = resource.bannable
      @status_change_action = params[:status_change_action]
      render template: 'pm/users/confirm_status_change', layout: false
    end

    [:disable, :enable, :approve, :reject].each do |status_change_action|
      base.send(:member_action, status_change_action, method: :put) do
        resource.send("#{status_change_action.to_s}_with_comment" , params[:user][:status_change_comment])
        status_change_notice =
            case status_change_action
              when :ban
                "User Banned!"
              when :enable
                "User Disabled!"
              when :approve
                "User Approved!"
              when :reject
                "User Rejected!"
            end
        redirect_to send("pm_#{resource.class.name.pluralize.underscore}_path"), notice: status_change_notice
      end
    end
  end

end