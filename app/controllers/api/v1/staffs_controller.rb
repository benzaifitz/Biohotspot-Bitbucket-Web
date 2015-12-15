module Api
  module V1
    class StaffsController < ApiController
      before_action :authenticate_user!
      before_action :set_staff, only: [:show, :update]

      # GET /api/v1/staffs/1.json
      def show
      end

      # PATCH/PUT /api/v1/staffs/1.json
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
        permitted_params = [:first_name, :last_name, :email, :company]
        permitted_params += [:password] if params[:staff] && !params[:staff][:password].blank?
        params.require(:staff).permit(permitted_params)
      end
    end
  end
end
