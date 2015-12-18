module Api
  module V1
    class JobsController < ApiController
      before_action :authenticate_user!
      before_action :set_job, only: [:show, :edit, :update, :destroy]
      
      # GET /api/v1/jobs.json
      api :GET, '/jobs.json', 'If customer is logged in that it returns all the jobs offered by the customer or if staff is logged in than all jobs accepted by staff will be returned.'
      def index
        @jobs = []
        if current_user.customer?
          @jobs = Job.where(offered_by: current_user)
        elsif current_user.staff?
          @jobs = Job.where(user: current_user)
        end
      end

      # GET /api/v1/jobs/1.json
      api :GET, '/jobs/:id.json', 'Returns info of the job.'
      param :id, Integer, desc: 'ID of the job.', required: true
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
      api :POST, '/jobs.json', 'Create a new job.'
      param :user_id, Integer, desc: 'Id of the user whom job is offered.', required: false
      def create
        return render json: {error: 'User Must be a customer to create a job.'} if !current_user.customer?
        @job = Job.new(job_params.merge(offered_by: current_user))
        if @job.save
          render :show
        else
          render json: @job.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/jobs/1.json
      api :PUT, '/jobs/:id.json', 'Update the job.'
      param :id, Integer, desc: 'Id of the job which is to be updated.', required: true
      param :status, Integer, desc: 'New status of the job. possible values 0 (offered), 1 (completed), 2 (accepted), 3 (cancelled), 4 (rejected), 5 (withdrawn)', required: false
      def update
        if @job.update(job_params.merge(current_user_type: current_user.user_type))
          render :show
        else
          render json: @job.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/jobs/1
      # DELETE /api/v1/jobs/1.json
      api :DELETE, '/jobs/:id.json', 'Delete the job.'
      param :id, Integer, desc: 'Id of the job which is to be deleted.', required: true
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


