module Api
  module V1
    class ConversationsController < ApiController
      before_action :authenticate_user!
      respond_to :json

      def index
        @conversations = Conversation.all
        respond_with @conversations
      end

      def create
        @conversation = Conversation.new(conversation_params)
        begin
          @conversation.save!
          respond_with @conversation
        rescue *RecoverableExceptions => e
          error(E_INTERNAL, @conversation.errors.full_messages[0])
        end
      end

      private

      def conversation_params
        params.require(:conversation).permit(:user_id, :from_user_id)
      end

    end
  end
end