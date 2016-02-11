module Api
  module V1
    class ConversationsController < ApiController
      before_action :authenticate_user!
      before_action :check_user_eula_and_privacy

      respond_to :json

      api :GET, '/conversations.json', 'Returns all conversations that they are the to/from user or user has participated in(community).'
      def index
        @conversations = Conversation.includes(:recipient, :from_user).get_all_chats_for_user(current_user.id)
                             .paginate_with_timestamp(params[:timestamp], params[:direction])
      end

      api :POST, '/conversations.json', 'Create a new conversation. Accepts from_user_id, user_id, name and conversation_type{direct: 0, community: 1}'
      def create
        @conversation = Conversation.users_direct_chat(current_user.id, conversation_params[:user_id]) || Conversation.new(conversation_params.merge(from_user_id: current_user.id))
        begin
          @conversation.save! if @conversation.new_record?
          render json: @conversation
        rescue *RecoverableExceptions => e
          error(E_INTERNAL, @conversation.errors.full_messages[0])
        end
      end

      api :PUT, '/conversations/:conversation_id/add_participants.json', 'Add participant to a public conversation. Will do nothing for private conversations. Accepts comma separated participant_ids list like "2,3,32,45"'
      def add_participants
        @conversation = Conversation.where(from_user: current_user, id: params[:conversation_id]).first
        @conversation.add_participants(params[:participant_ids])
        if @conversation.errors.empty?
          render json: {success: 'Participants added successfully.'}, status: :ok
        else
          error(E_INTERNAL, @conversation.errors.full_messages[0])
        end
      end

      api :get, '/conversations/:conversation_id/participants.json', 'Get a list of all the participants of a conversation.'
      def participants
        @conversation = Conversation.where(from_user: current_user, id: params[:conversation_id]).first
        respond_with @conversation.conversation_participants
      end

      api :DELETE, '/conversations/:id.json', 'Delete a conversation that you are participant of(Does not delete conversation. It just wont appear in your listing. Other participant will be able to see it.)'
      def destroy
        @conversation = Conversation.find(params[:id])
        if @conversation.has_participant?(current_user.id)
          deleted_conversation = DeletedConversation.new(user_id: current_user.id, conversation_id: @conversation.id)
          begin
            deleted_conversation.save!
            render json: {success: 'Conversation has been deleted successfully.'}
          rescue *RecoverableExceptions => e
            error(E_INTERNAL, deleted_conversation.errors.full_messages[0])
          end
        else
          error(E_INTERNAL, "You are not a participant of this conversation.")
        end
      end
      private

      def conversation_params
        params.require(:conversation).permit(:user_id, :name, :conversation_type)
      end

    end
  end
end