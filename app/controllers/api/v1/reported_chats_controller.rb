module Api
  module V1
    class ReportedChatsController < ApiController
      before_action :authenticate_user!
      before_action :set_reported_chat, only: [:show]

      def show
      end

      api :POST, '/reported_chats.json', 'Create a new reported chat.'
      def create
        @reported_chat = ReportedChat.new(reported_chat_params.merge(reported_by_id: 14))
        begin
          @reported_chat.save!
          render :show
        rescue *RecoverableExceptions => e
          error(E_INTERNAL, @reported_chat.errors.full_messages[0])
        end
      end


      private
      def set_reported_chat
        @reported_chat = ReportedChat.find(params[:id])
      end
      # Never trust parameters from the scary internet, only allow the white list through.
      def reported_chat_params
        params.require(:reported_chat).permit([:chat_id])
      end
    end
  end
end
