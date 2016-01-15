module Api
  module V1
    class ConversationsController < ApiController
      before_action :authenticate_user!
      before_action :check_user_eula_and_privacy

      respond_to :json

      api :GET, 'conversations.json', 'Returns all conversations that they are the to/from user or user has participated in(community). pass 1 in conversation_type for community chat'
      def index
        @conversations = Conversation.includes(:recipient, :from_user).get_all_chats_for_user(current_user.id)
                             .paginate_with_timestamp(params[:timestamp], params[:direction])
      end

      api :POST, 'conversations.json', 'Create a new conversation. Accepts from_user_id, user_id, name and conversation_type{direct: 0, community: 1}'
      def create
        @conversation = Conversation.new(conversation_params.merge(from_user_id: current_user.id))
        begin
          @conversation.save!
          render json: @conversation
        rescue *RecoverableExceptions => e
          error(E_INTERNAL, @conversation.errors.full_messages[0])
        end
      end

      api :PUT, 'conversations/:conversation_id/add_participants.json', 'Add participant to a public conversation. Will do nothing for private conversations. Accepts comma separated participant_ids list'
      def add_participants
        @conversation = Conversation.where(from_user: current_user, id: params[:conversation_id]).first
        @conversation.add_participants(params[:participant_ids])
        if @conversation.errors.empty?
          render json: {success: 'Participants added successfully.'}, status: :ok
        else
          error(E_INTERNAL, @conversation.errors.full_messages[0])
        end
      end

      api :get, 'conversations/:conversation_id/participants.json', 'Get a list of all the participants of a conversation.'
      def participants
        @conversation = Conversation.where(from_user: current_user, id: params[:conversation_id]).first
        respond_with @conversation.conversation_participants
      end

      private

      def conversation_params
        params.require(:conversation).permit(:user_id, :name, :conversation_type)
      end

    end
  end
end