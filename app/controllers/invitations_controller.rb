class InvitationsController < ApplicationController
  layout 'layouts/active_admin_logged_out'

  def accept_invitation
    if params[:token]
      token, project, user = Base64.urlsafe_decode64(params[:token]).split('_')
      @user = ProjectManager.find(user)
      if !@user.confirmed? 
        if ProjectManagerProject.where(project_id: project, project_manager_id: user, token: token).present?
          @project = Project.find(project)
          if @user.save
            render 'invitations/accept_invitation', :user => @user
          end
        end
      else
        flash[:error] = 'Please login, you are already part of the system'
        redirect_to pm_root_path
      end
    else
      render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
    end
  end

  def accept
    params[:project_manager] = params[:project_manager].merge(confirmed_at: Time.current, approved: true)
    if params[:project_manager].present?
      user = User.find(params[:user])
      if params[:project_manager][:password] == params[:project_manager][:password_confirmation]
        permitted = params.require(:project_manager).permit(:email, :password, :password_confirmation, :confirmed_at, :approved)
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
