module Api
  module V1
    class TutorialsController < ApiController
      before_action :authenticate_user!

      def help
        @tutorials = show_tutorial
      end

      #if user is sign in for the first time, tutorial will be shown to the user
      def index
        if current_user.sign_in_count == 1
          @tutorials = show_tutorial
        end
      end

      def create
        @tutorial = Tutorial.new(tutorial_params)
        begin
          @tutorial.save!
          render json: {success: 'Tutorial successfully created'}
        rescue *RecoverableExceptions => e
          error(E_INTERNAL, @tutorial.errors.full_messages[0])
        end
      end

      private
      # Use callbacks to share common setup or constraints between actions.

      def show_tutorial
        Tutorial.first(5).map{|a|{ id: a.id, avatar_url: "#{request.host_with_port}#{a.avatar.url}", avatar_text: a.avatar_text}}
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def tutorial_params
        params.require(:tutorial).permit([:avatar, :avatar_text])
      end
    end
  end
end

