module Api
  module V1
    class CustomersController < ApiController
      before_action :authenticate_user!
      before_action :check_user_eula_and_privacy, except: [:update]
      before_action :verify_customer, only: [:update]
      before_action :set_customer, only: [:show]

      #POST /
      api :POST, '/auth/', 'Create a new user(project_manager or land_manager). No encapsulation needed'
      param :email, String
      param :password, String
      param :password_confirmation, String
      param :first_name, String
      param :last_name, String
      param :user_type, Integer, desc: 'Project Manager => 0, Land Manager => 2. By default a user will be a project_manager'
      param :company, String, desc: 'Required for project_manager type user'
      param :username, String, desc: 'Required. Unique username of user. Allowed characters are A to Z, a to z, 0 to 9 and _(underscore)'
      param :eula_id, Integer, desc: 'id of accepted terms and conditions(EULA)'
      param :privacy_id, Integer, desc: 'id of accepted privacy policy'
      param :device_token, Integer, desc: 'device token'
      param :device_type, Integer, desc: 'ios/android'
      def register
        #Dummy stub to provide API docs
      end

      # GET /api/v1/customers/1.json
      api :GET, '/customers/:id.json', 'Show single land_manager resource.'
      # param :id, Integer, desc: 'ID of land_manager to be shown.', required: true
      def show
      end

      # PATCH/PUT /api/v1/customers/1.json
      api :PUT, '/customers/:id.json', 'Update single land_manager resource.'
      # param :id, Integer, desc: 'ID of land_manager to be updated', required: true
      param :first_name, String, desc: 'First Name of the land_manager', required: false
      param :last_name, String, desc: 'Last Name of the land_manager', required: false
      param :email, String, desc: 'Email of the land_manager', required: false
      param :company, String, desc: 'Company name of the land_manager', required: false
      param :eula_id, Integer, desc: 'Eula ID which has been accepted by the land_manager', required: false
      param :privacy_id, Integer, desc: 'Privacy policy ID which has been accepted by the land_manager', required: false
      param :password, String, desc: 'Password of the land_manager', required: false
      param :device_token, String, desc: 'Device Token', required: false
      param :device_type, String, desc: 'Device Type (ios,android)', required: false
      param :image_data, String, desc: 'Base64 encoded profile picture image data', required: false
      param :image_type, String, desc: 'Image content type of profile picture. Must be provided if image_data is sent. e.g image/jpeg', required: false
      def update
        @land_manager = current_user
        begin
          if params[:land_manager][:device_token].present?
            @users = User.where(device_token: params[:land_manager][:device_token])
            @users.each do |u|
              u.update_attributes!(device_token: nil, device_type: nil)
            end
          end
          @land_manager.assign_attributes(customer_params)
          @land_manager.image_data(params[:land_manager][:image_data], params[:land_manager][:image_type]) if params[:land_manager][:image_data].present? && params[:land_manager][:image_type].present?
          @land_manager.save!
          render :show
        rescue *RecoverableExceptions => e
          error(E_INTERNAL, @land_manager.errors.full_messages[0])
        end
        # if @land_manager.update(customer_params)
        #   render :show
        # else
        #   render json: @land_manager.errors, status: :unprocessable_entity
        # end
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_customer
        if current_user.project_manager?
          @land_manager = Land Manager.includes(:rated_on_ratings).find(params[:id])
        elsif current_user.land_manager?
          @land_manager = current_user
        end
      end

      def verify_customer
        error(E_INTERNAL, 'Update not allowed.') if params[:id].to_i != current_user.id
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def customer_params
        permitted_params = [:first_name, :last_name, :email, :company, :eula_id, :privacy_id, :device_token, :device_type]
        permitted_params += [:password] if params[:land_manager] && !params[:land_manager][:password].blank?
        params.require(:land_manager).permit(permitted_params)
      end
    end
  end
end

