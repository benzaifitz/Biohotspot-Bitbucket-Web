class Api::Admin::UsersController < ApiController
  
  before_action :authenticate_user!
  #TODO: Add authorization layer
  respond_to :json
  
  def index
    @users = User.all
    respond_with @users
  end
  
  def create
    @user = User.new(user_params)
    respond_with(@user) if @user.save
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :user_type)
  end
end
