module Api
  module V1
    class SubmissionsController < ApiController
      before_action :authenticate_user!
      before_action :set_submission, only: [:show, :destroy, :update]

      api :GET, '/submissions.json', 'Return all submissions. Send params (unknown_submission= true) to get all unknown submissions'
      def index
        if params[:unknown_submission] == 'true'
          @submissions = Submission.where(sub_category_id: nil)
        else
          @submissions = Submission.where.not(sub_category_id: nil).where(submitted_by: current_user.id)
        end
      end

      api :GET, '/submissions/:id.json', 'Return single submission'
      def show
      end

      api :POST, '/submissions.json', 'Create a submission'
      param :survey_number, String, desc:'', required: false
      param :submitted_by, Integer, desc:'', required: false
      param :latitude, Float, desc:'', required: false
      param :longitude, Float, desc:'', required: false
      param :sub_category_id, Integer, desc:'', required: false
      param :rainfall, String, desc:'', required: false
      param :humidity, String , desc:'', required: false
      param :temperature,String, desc:'', required: false
      param :health_score, String, desc:'value must be between 1-5', required: false
      param :live_leaf_cover, String, desc:'value must be between 1-5', required: false
      param :live_branch_stem, String, desc:'value must be between 1-5', required: false
      param :stem_diameter, String, desc:'value must be between 1-5', required: false
      param :sample_photo_full_url, String, desc:'Required true', required: false
      param :monitoring_photo_full_url, String, desc:'Required true', required: false
      param :dieback, Integer, desc:'value must be between 1-5', required: false
      param :leaf_tie_month, [true, false], desc:'', required: false
      param :seed_borer, [true, false], desc:'', required: false
      param :loopers, [true, false], desc:'', required: false
      param :grazing, [true, false], desc:'', required: false
      param :field_notes, String, desc:'', required: false
      param :status, Integer, desc: 'Should be send outside submission hash.0 for complete and 1 for incomplete', required: false
      def create
        @submission = Submission.new(submission_params.merge(submitted_by: current_user.id))
        begin
          @submission.save_by_status
          photos_for_submission(params, @submission)
          render :show
        rescue *RecoverableExceptions => e
          error(E_INTERNAL, @submission.errors.full_messages[0])
        end
      end

      api :PUT, '/submissions/:id.json', 'Update a submission'
      param :survey_number, String, desc:'', required: false
      param :submitted_by, Integer, desc:'', required: false
      param :latitude, Float, desc:'', required: false
      param :longitude, Float, desc:'', required: false
      param :sub_category_id, Integer, desc:'', required: false
      param :rainfall, String, desc:'', required: false
      param :humidity, String , desc:'', required: false
      param :temperature,String, desc:'', required: false
      param :health_score, String, desc:'value must be between 1-5', required: false
      param :live_leaf_cover, String, desc:'value must be between 1-5', required: false
      param :live_branch_stem, String, desc:'value must be between 1-5', required: false
      param :stem_diameter, String, desc:'value must be between 1-5', required: false
      param :sample_photo_full_url, String, desc:'Required true', required: false
      param :monitoring_photo_full_url, String, desc:'Required true', required: false
      param :dieback, Integer, desc:'value must be between 1-5', required: false
      param :leaf_tie_month, [true, false], desc:'', required: false
      param :seed_borer, [true, false], desc:'', required: false
      param :loopers, [true, false], desc:'', required: false
      param :grazing, [true, false], desc:'', required: false
      param :field_notes, String, desc:'', required: false
      param :status, Integer, desc: 'Should be send outside submission hash.0 for complete and 1 for incomplete', required: false
      def update
        @submission.attributes = @submission.attributes.merge!(submission_params.merge(submitted_by: current_user.id))
        if @submission.save_by_status
          photos_for_submission(params, @submission)
          render :show
        else
          render json: {error: @submission.errors.messages}, status: :unprocessable_entity
        end
      end

      api :DELETE, '/submissions/:id.json', 'Delete single submissions'
      def destroy
        @submission.destroy
        render json: {success: true, status: 200}
      end

      private

      def photos_for_submission params, submission
        if params[:submission][:photos].present?
          submission.photos.destroy_all
          params[:submission][:photos].each do |photo|
            Photo.create(url: photo['url'], imageable_id: submission.id, imageable_type: 'Submission')
          end
        end
      end

      def set_submission
        @submission = Submission.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def submission_params
        params.require(:submission).permit([:survey_number, :submitted_by, :latitude, :longitude, :sub_category_id,
                                            :rainfall, :humidity, :temperature, :health_score, :live_leaf_cover, :status,
                                            :live_branch_stem, :stem_diameter, :sample_photo_full_url, :monitoring_photo_full_url,
                                            :dieback, :leaf_tie_month, :seed_borer, :loopers, :grazing, :field_notes])
      end
    end
  end
end

