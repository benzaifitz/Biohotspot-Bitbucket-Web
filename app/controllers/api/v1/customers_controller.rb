module Api
  module V1
    class CustomersController < ApiController
      before_action :authenticate_user!
      before_action :set_customer, only: [:show, :update]

    # GET /api/v1/customers/1.json
    def show
    end

    # PATCH/PUT /api/v1/customers/1.json
    def update
      if @customer.update(customer_params)
        render :show
      else
        render json: @customer.errors, status: :unprocessable_entity
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = current_user || Customer.new
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      permitted_params = [:first_name, :last_name, :email, :company]
      permitted_params += [:password] if params[:customer] && !params[:customer][:password].blank?
      params.require(:customer).permit(permitted_params)
    end
  end
end
end

