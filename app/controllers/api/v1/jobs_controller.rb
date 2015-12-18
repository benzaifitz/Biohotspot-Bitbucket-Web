module Api
  module V1
    class JobsController < ApiController
      before_action :authenticate_user!
      before_action :set_job, only: [:show, :edit, :update, :destroy]
      
      # GET /api/v1/jobs.json
      def index
        @jobs = []
        if current_user.customer?
          @jobs = Job.where(offered_by: current_user)
        elsif current_user.staff?
          @jobs = Job.where(user: current_user)
        end
      end

      # GET /api/v1/jobs/1
      # GET /api/v1/jobs/1.json
      def show
      end

      # GET /api/v1/jobs/new
      def new
        @job = Job.new
      end

      # GET /api/v1/jobs/1/edit
      def edit
      end

      # POST /api/v1/jobs.json
      def create
        return render json: {error: 'User Must be a customer to create a job.'} if !current_user.customer?
        @job = Job.new(job_params.merge(offered_by: current_user))
        if @job.save
          render :show
        else
          render json: @job.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/jobs/1
      # PATCH/PUT /api/v1/jobs/1.json
      def update
        if @job.update(job_params.merge(current_user_type: current_user.user_type))
          render :show
        else
          render json: @job.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/jobs/1
      # DELETE /api/v1/jobs/1.json
      def destroy
        @job.destroy
        respond_to do |format|
          format.html { redirect_to jobs_url, notice: 'Job was successfully destroyed.' }
          format.json { head :no_content }
        end
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_job
        @job = Job.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def job_params
        permitted_params = [:user_id, :status, :description]
        params.require(:job).permit(permitted_params)
      end

    end
  end
end


