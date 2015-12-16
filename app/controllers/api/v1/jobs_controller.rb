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

      # POST /api/v1/jobs
      # POST /api/v1/jobs.json
      def create
        @job = Job.new(job_params)

        respond_to do |format|
          if @job.save
            format.html { redirect_to @job, notice: 'Job was successfully created.' }
            format.json { render :show, status: :created, location: @job }
          else
            format.html { render :new }
            format.json { render json: @job.errors, status: :unprocessable_entity }
          end
        end
      end

      # PATCH/PUT /api/v1/jobs/1
      # PATCH/PUT /api/v1/jobs/1.json
      def update
        respond_to do |format|
          if @job.update(job_params)
            format.html { redirect_to @job, notice: 'Job was successfully updated.' }
            format.json { render :show, status: :ok, location: @job }
          else
            format.html { render :edit }
            format.json { render json: @job.errors, status: :unprocessable_entity }
          end
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
        params[:job]
      end
    end
  end
end


