module Api
  module V1
    class CustomersController < ApiController
      before_action :authenticate_user!
      before_action :check_user_eula_and_privacy, except: [:update]
      before_action :verify_customer, only: [:update]
      before_action :set_customer, only: [:show]

      # GET /api/v1/customers/1.json
      api :GET, '/customers/:id.json', 'Show single customer resource.'
      # param :id, Integer, desc: 'ID of customer to be shown.', required: true
      def show
      end

      # PATCH/PUT /api/v1/customers/1.json
      api :PUT, '/customers/:id.json', 'Update single customer resource.'
      # param :id, Integer, desc: 'ID of customer to be updated', required: true
      param :first_name, String, desc: 'First Name of the customer', required: false
      param :last_name, String, desc: 'Last Name of the customer', required: false
      param :email, String, desc: 'Email of the customer', required: false
      param :company, String, desc: 'Company name of the customer', required: false
      param :eula_id, Integer, desc: 'Eula ID which has been accepted by the customer', required: false
      param :password, String, desc: 'Password of the customer', required: false
      param :device_token, String, desc: 'Device Token', required: false
      param :device_type, String, desc: 'Device Type (iOS,Android)', required: false
      def update
        @customer = current_user
        begin
          @customer.update(customer_params)
          render :show
        rescue *RecoverableExceptions => e
          error(E_INTERNAL, @customer.errors.full_messages[0])
        end
        # if @customer.update(customer_params)
        #   render :show
        # else
        #   render json: @customer.errors, status: :unprocessable_entity
        # end
      end

      # PATCH/PUT /api/v1/customers/1/update_profile_picture.json
      api :put, '/customers/:customer_id/update_profile_picture.json', 'Update profile picture of currently signed in user. Accepts image_data, image_extension, image_type(image/jpeg), image_name e.g {staff: image_data: "base 64 encoded data"..}'
      def update_profile_picture
        current_user.image_data(customer_params[:image_data], customer_params[:image_type])
        if current_user.save
          render json: {id: current_user.id, profile_picture_url: current_user.profile_picture_url}
        else
          error(E_INTERNAL, current_user.errors.full_messages[0])
        end
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_customer
        if current_user.staff?
          @customer = Customer.includes(:rated_on_ratings).find(params[:id])
        elsif current_user.customer?
          @customer = current_user
        end
      end

      def verify_customer
        error(E_INTERNAL, 'Update not allowed.') if params[:id].to_i != current_user.id
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def customer_params
        permitted_params = [:first_name, :last_name, :email, :company, :eula_id, :privacy_id, :device_token, :device_type, :image_data, :image_type, :image_extension, :image_name]
        permitted_params += [:password] if params[:customer] && !params[:customer][:password].blank?
        params.require(:customer).permit(permitted_params)
      end
    end
  end
end

