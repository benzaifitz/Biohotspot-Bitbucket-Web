module Api
  module V1
    class ConversationsController < ApiController
      before_action :authenticate_user!
      respond_to :json

      api :GET, 'conversations.json', 'Returns all conversations that they are the to/from user or user has participated in(community). pass 1 in conversation_type for community chat'
      def index
        @conversations = Conversation.get_all_chats_for_user(current_user.id)
                             .paginate_with_timestamp(params[:timestamp], params[:direction])
        respond_with @conversations
      end

      api :POST, 'conversations.json', 'Create a new conversation. Accepts from_user_id, user_id, name and conversation_type'
      def create
        @conversation = Conversation.new(conversation_params.merge(from_user_id: current_user.id))
        begin
          @conversation.save!
          render json: @conversation
        rescue *RecoverableExceptions => e
          error(E_INTERNAL, @conversation.errors.full_messages[0])
        end
      end

      api :PUT, 'conversations/:id/add_participants.json', 'Add participant to a public conversation. Will do nothing for private conversations. Accepts participant_ids array'
      def add_participants
        @conversation = Conversation.find(params[:id])
        @conversation.add_participants(params[:participant_ids])
        if @conversation.errors.empty?
          render :nothing, status: :ok
        else
          error(E_INTERNAL, @conversation.errors.full_messages[0])
        end
      end

      private

      def conversation_params
        params.require(:conversation).permit(:user_id, :name, :conversation_type)
      end

    end
  end
end