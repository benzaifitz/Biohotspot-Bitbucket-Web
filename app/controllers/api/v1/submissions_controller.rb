module Api
  module V1
    class SubmissionsController < ApiController
      before_action :authenticate_user!
      before_action :set_submission, only: [:show, :destroy, :update]

      api :GET, '/submissions.json', 'Return all submissions'
      def index
        @submissions = Submission.all
      end

      api :GET, '/submissions/:id.json', 'Return single submission'
      def show
      end

      api :POST, '/submissions.json', 'Create a submission'
      param :survey_number, String, desc:'', required: false
      param :submitted_by, Integer, desc:'', required: false
      param :lat, Float, desc:'', required: false
      param :long, Float, desc:'', required: false
      param :sub_category_id, Integer, desc:'', required: false
      param :rainfall, String, desc:'', required: false
      param :humidity, String , desc:'', required: false
      param :temperature,String, desc:'', required: false
      param :health_score, Float, desc:'', required: false
      param :live_leaf_cover, String, desc:'', required: false
      param :live_branch_stem, String, desc:'', required: false
      param :stem_diameter, Float, desc:'', required: false
      def create
        @submission = Submission.new(submission_params)
        begin
          @submission.save!
          render :show
        rescue *RecoverableExceptions => e
          error(E_INTERNAL, @submission.errors.full_messages[0])
        end
      end

      api :PUT, '/submissions/:id.json', 'Update a submission'
      param :survey_number, String, desc:'', required: false
      param :submitted_by, Integer, desc:'', required: false
      param :lat, Float, desc:'', required: false
      param :long, Float, desc:'', required: false
      param :sub_category_id, Integer, desc:'', required: false
      param :rainfall, String, desc:'', required: false
      param :humidity, String , desc:'', required: false
      param :temperature,String, desc:'', required: false
      param :health_score, Float, desc:'', required: false
      param :live_leaf_cover, String, desc:'', required: false
      param :live_branch_stem, String, desc:'', required: false
      param :stem_diameter, Float, desc:'', required: false
      def update
        if !@submission.blank? && @submission.update(submission_params)
          render :show
        else
          render json: {error: 'Submission not found.'}, status: :unprocessable_entity
        end
      end

      api :DELETE, '/submissions/:id.json', 'Delete single submissions'
      def destroy
        @submission.destroy
        render json: {success: true, status: 200}
      end

      private

      def set_submission
        @submission = Submission.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def submission_params
        params.require(:submission).permit([:survey_number, :submitted_by, :lat, :long, :sub_category_id, :rainfall, :humidity, :temperature, :health_score, :live_leaf_cover, :live_branch_stem, :stem_diameter])
      end
    end
  end
end

