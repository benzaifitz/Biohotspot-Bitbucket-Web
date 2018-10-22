class InvitationsController < ApplicationController
  layout 'layouts/active_admin_logged_out'

  def accept_invitation
    if params[:token]
      token, project, user = Base64.urlsafe_decode64(params[:token]).split('_')
      @user = User.find(user)
      pmp = ProjectManagerProject.where(project_id: project, project_manager_id: user, token: token).first
      if pmp.present?
        pmp.update_attributes!(status: 'accepted')
        @project = Project.find(project)
      end
      if @user.pm_invited? && !@user.confirmed?
        if @user.save
          render 'invitations/accept_invitation', :user => @user
        end
      elsif @user.land_manager?
        @user.update_attributes!(user_type: 'project_manager')
        redirect_to pm_root_path
      else
        flash[:error] = 'Please login, you are already part of the system'
        redirect_to pm_root_path
      end
    else
      render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
    end
  end

  def accept
    params[:project_manager] = params[:project_manager].merge(confirmed_at: Time.current, approved: true, pm_invited: false)
    if params[:project_manager].present?
      user = User.find(params[:user])
      if params[:project_manager][:password] == params[:project_manager][:password_confirmation]
        permitted = params.require(:project_manager).permit(:email, :password, :password_confirmation, :confirmed_at, :approved, :pm_invited)
        user.update!(permitted)
        sign_in user
        redirect_to pm_projects_path
      end
    else
    end
  end

  def reject_invitation
    flash[:notice] = 'You have been invited to project'
    redirect_to pm_root_path
  end


end
