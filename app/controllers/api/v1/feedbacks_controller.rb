module Api
  module V1
    class FeedbacksController < ApiController
      before_action :authenticate_user!
      before_action :check_user_eula_and_privacy
      before_action :set_feedback, only: [:show]

      # GET /api/v1/feedbacks/1.json
      api :GET, '/feedbacks/:id.json', 'Returns feedback info for given ID.'
      param :id, String, desc: 'ID of the rating.', required: false
      def show
      end

      # POST /api/v1/feedbacks.json
      api :POST, '/feedbacks.json', 'Create a new feedback.'
      param :comment, String, desc: 'Comment.{"feedback":{"comment":"ABC"}}', required: false
      def create
        @feedback = Feedback.new(feedback_params.merge(land_manager_id: current_user.id, project_id: current_user.project.id))
        begin
          @feedback.save!
          render :show
        rescue *RecoverableExceptions => e
          error(E_INTERNAL, @feedback.errors.full_messages[0])
        end
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_feedback
        @feedback = Feedback.find(params[:id])
      end

      def feedback_params
        permitted_params = [:comment]
        params.require(:feedback).permit(permitted_params)
      end

    end
  end
end

