module Api
  module V1
    class StaffsController < ApiController
      before_action :authenticate_user!
      before_action :check_user_eula_and_privacy, except: [:update]
      before_action :verify_staff, only: [:update]
      before_action :set_staff, only: [:show, :update]

      #POST /
      api :POST, '/auth/', 'Create a new user(staff or customer). No encapsulation needed'
      param :email, String
      param :password, String
      param :password_confirmation, String
      param :first_name, String
      param :last_name, String
      param :user_type, Integer, desc: 'Staff => 0, Customer => 2. By default a user will be a staff'
      param :company, String, desc: 'Required for staff type user'
      param :username, String, desc: 'Required. Unique username of user. Allowed characters are A to Z, a to z, 0 to 9 and _(underscore)'
      param :eula_id, Integer, desc: 'id of accepted terms and conditions(EULA)'
      param :privacy_id, Integer, desc: 'id of accepted privacy policy'
      param :device_token, Integer, desc: 'device token'
      param :device_type, Integer, desc: 'ios/android'
      def register
        #Dummy stub to provide API docs
      end

      #GET /api/v1/staffs.json
      api :GET, '/staffs.json', 'Return a list of staff with or without a search query'
      param :query, String, desc: 'Search staff resources with name. If not provided will return a list of all staff 20 records at a time'
      param :offset, String, desc: 'Offset of the records to be fetched. e.g offset=22'
      def index
        query = params[:query] || ""
        first_name, last_name = query.split(' ')
        @staffers = Staff.without_blocked_users(current_user.id).search({first_name: first_name,
                      last_name: last_name}).offset(params[:offset].to_i || 0).order('id DESC').limit(Api::V1::LIMIT)
      end

      # GET /api/v1/staffs/1.json
      api :GET, '/staffs/:id.json', 'Show single staff resource.'
      # param :id, Integer, desc: 'ID of Staff to be shown.', required: true
      def show
      end

      # PATCH/PUT /api/v1/staffs/1.json
      api :PUT, '/staffs/:id.json', 'Update single staff resource.'
      # param :id, Integer, desc: 'ID of Staff to be updated', required: true
      param :first_name, String, desc: 'First Name of the Staff', required: false
      param :last_name, String, desc: 'Last Name of the Staff', required: false
      param :email, String, desc: 'Email of the Staff', required: false
      param :company, String, desc: 'Company name of the Staff', required: false
      param :eula_id, Integer, desc: 'Eula ID which has been accepted by the Staff', required: false
      param :privacy_id, Integer, desc: 'Privacy policy ID which has been accepted by the Staff', required: false
      param :password, String, desc: 'Password of the Staff', required: false
      param :device_token, String, desc: 'Device Token', required: false
      param :device_type, String, desc: 'Device Type (ios,android)', required: false
      param :image_data, String, desc: 'Base64 encoded profile picture image data', required: false
      param :image_type, String, desc: 'Image content type of profile picture e.g image/jpeg', required: false
      def update
        @staff = current_user
        begin
          @staff.assign_attributes(staff_params)
          @staff.image_data(params[:staff][:image_data], params[:staff][:image_type]) if params[:staff][:image_data].present? && params[:staff][:image_type].present?
          @staff.save!
          render :show
        rescue *RecoverableExceptions => e
          error(E_INTERNAL, @staff.errors.full_messages[0])
        end
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_staff
        if current_user.staff?
          @staff = current_user
        elsif current_user.customer?
          @staff = Staff.includes(:rated_on_ratings).find(params[:id])
        end
      end

      def verify_staff
        error(E_INTERNAL, 'Update not allowed.') if params[:id].to_i != current_user.id
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def staff_params
        permitted_params = [:first_name, :last_name, :email, :company, :eula_id, :privacy_id, :device_token, :device_type]
        permitted_params += [:password] if params[:staff] && !params[:staff][:password].blank?
        params.require(:staff).permit(permitted_params)
      end
    end
  end
end
