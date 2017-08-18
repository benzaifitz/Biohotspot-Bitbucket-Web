module Api
  module V1
    module Users
      class Users::RegistrationsController < Devise::RegistrationsController

        def create
          @user = User.new(user_params)
          respond_to do |format|
            if @user.save!
              format.json { render json:
                            {
                              success: 'User added successfully.',
                              term_and_conditions: Eula.where(is_latest: true).all.map{|a| {eula_id: a.id, text: a.eula_text}}.first
                            }, status: :ok
                          }
            else
              format.json { render json: {errors: @user.errors, status: :unprocessable_entity } }
            end
          end
        end

        private

        def user_params
          params.require(:user).permit(:email, :password, :password_confirmation, :user_type, :mobile_number, :project_id, :username)
        end

      end
    end
  end
end


