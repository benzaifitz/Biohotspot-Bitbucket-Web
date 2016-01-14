module Api
  module V1
    class StaffsController < ApiController
      before_action :authenticate_user!
      before_action :verify_staff, only: [:update]
      before_action :set_staff, only: [:show, :update]

      #GET /api/v1/staffs.json
      api :GET, '/staffs.json', 'Return a list of staff with or without a search query'
      param :query, String, desc: 'Search staff resources with name. If not provided will return a list of all staff 20 records at a time'
      param :offset, String, desc: 'Offset of the records to be fetched. e.g offset=22'
      def index
        query = params[:query] || ""
        first_name, last_name = query.split(' ')
        @staffers = Staff.without_blocked_users(current_user.id).search({first_name: first_name,
                      last_name: last_name}).offset(params[:offset].to_i || 0).order('id DESC').limit(20)
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
      param :password, String, desc: 'Password of the Staff', required: false
      param :device_token, String, desc: 'Device Token', required: false
      param :device_type, String, desc: 'Device Type (iOS,Android)', required: false
      def update
        @staff = current_user
        begin
          @staff.update(staff_params)
          render :show
        rescue *RecoverableExceptions => e
          error(E_INTERNAL, @staff.errors.full_messages[0])
        end
      end

      # PATCH/PUT /api/v1/staffs/1/update_profile_picture.json
      api :PUT, '/staffs/:id/update_profile_picture.json', 'Update profile picture of currently signed in user. Accepts image_data, image_extension, image_type(image/jpeg), image_name e.g {staff: image_data: "base 64 encoded data"..}'
      def update_profile_picture
        current_user.update(convert_data_to_upload(staff_params))
        if current_user.errors.empty?
          render json: {id: current_user.id, profile_picture_url: current_user.profile_picture_url}
        else
          error(E_INTERNAL, current_user.errors.full_messages[0])
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
        permitted_params = [:first_name, :last_name, :email, :company, :eula_id, :device_token, :device_type, :image_data, :image_type, :image_extension, :image_name]
        permitted_params += [:password] if params[:staff] && !params[:staff][:password].blank?
        params.require(:staff).permit(permitted_params)
      end
    end
  end
end
