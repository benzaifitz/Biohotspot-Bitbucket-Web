module Api
  module V1
    class StaffsController < ApiController
      before_action :authenticate_user!
      before_action :set_staff, only: [:show, :update]

      # GET /api/v1/staffs/1.json
      api :GET, '/staffs/:id.json', 'Show single staff resource.'
      # param :id, Integer, desc: 'ID of Staff to be shown.', required: true
      def show
      end

      # PATCH/PUT /api/v1/staffs/1.json
      api :PUT, '/staffs/:id.json', 'Update single staff resource.'
      # param :id, Integer, desc: 'ID of Staff to be updated', required: true
      # param :first_name, String, desc: 'First Name of the Staff', required: false
      # param :last_name, String, desc: 'Last Name of the Staff', required: false
      # param :email, String, desc: 'Email of the Staff', required: false
      # param :company, String, desc: 'Company name of the Staff', required: false
      # param :eula_id, Integer, desc: 'Eula ID which has been accepted by the Staff', required: false
      # param :password, String, desc: 'Password of the Staff', required: false
      # param :device_token, String, desc: 'Device Token', required: false
      # param :device_type, String, desc: 'Device Type (iOS,Android)', required: false
      def update
        if @staff.update(staff_params)
          render :show
        else
          render json: @staff.errors, status: :unprocessable_entity
        end
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_staff
        @staff = current_user || Staff.new #Staff.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def staff_params
        permitted_params = [:first_name, :last_name, :email, :company, :eula_id, :device_token, :device_type]
        permitted_params += [:password] if params[:staff] && !params[:staff][:password].blank?
        params.require(:staff).permit(permitted_params)
      end
    end
  end
end
