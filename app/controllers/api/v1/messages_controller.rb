module Api
  module V1
    class MessagesController < ApiController
      before_action :authenticate_user!
      before_action :check_user_eula_and_privacy
      before_action :set_chat, only: [:update, :destroy]

      respond_to :json

      api :GET, 'conversations/:conversation_id/messages.json', 'Returns all messages in the given conversation ID and that belong to currently logged in user'
      param :timestamp, String, desc: 'Timestamp of the first or last record in the cache. timestamp and direction are to be used in conjunction', required: false
      param :direction, String, desc: 'Direction of records. up: 0 and down: 1, with up all records updated after the timestamp are returned, and with down 20 records updated before the timestamp will be returned', required: false
      param :order_by_attr, String, 'Attribute by which to order by. Default is updated_at', required: false
      param :order_by_direction, String, 'Direction of sorting. ASC for ascending and DESC for descending. Default is DESC', required: false
      def index
        conversation = Conversation.find(params[:conversation_id])
        if conversation.has_participant?(current_user.id)
          @chats = Chat.where(conversation_id: params[:conversation_id])
                               .paginate_with_timestamp(params[:timestamp], params[:direction])
          respond_with @chats
        else
          error(E_INTERNAL, 'The logged in user is not participant of this chat.')
        end
      end

      api :POST, 'conversations/:conversation_id/messages.json', 'Create a chat message for provided conversation ID. chat: {message: <message>}'
      param :conversation_id, String, desc: 'Id of the conversation.', required: false
      def create
        conversation = Conversation.find(params[:conversation_id])
        if conversation.has_participant?(current_user.id)
          message = conversation.chats.create!(chat_params.merge(from_user_id: current_user.id))
          # conversation.last_message = message[:body]
          # conversation.last_user_id = message[:user_id]
          #
          # sender = User.find(message[:user_id])
          # message_body = sender.name.capitalize + ' sent you a message'
          # if conversation.user_id == sender.id
          #   recipient = conversation.from_user
          # else
          #   recipient = conversation.user
          # end
          # recipient.user.push_notification_iphone(message_body)
          #other_recipient_id = other_recipient_name = ''
          #unless (conversation.from_user_id.nil? && conversation.user_id.nil?)
          #  other_recipient_id = message[:user_id].to_i
          #  if (conversation.from_user_id == message[:user_id].to_i)
          #   other_recipient_name = conversation.from_user.name
          #  else
          #    other_recipient_name = conversation.user.name
          # end
          #end
        end

        #conversation.recipients.each do |recipient|
        #  recipient.read = (message[:user_id] == recipient.user_id)
        #  recipient.save
        #
        #  if message[:body] && message[:user_id] != recipient.user_id
        #    # send push notification
        #    # recipient.user.push_notification_iphone(message_body)
        #  end

        #  conversation_count = Recipient.where(user_id: recipient.user_id, read: false).count
        #  conversation_ids = Recipient.where(user_id: recipient.user_id, read: false).pluck('conversation_id')
        #  socket = SocketIO::Client::Simple.connect ENV['NODE_CHAT_HOST']
        #  sleep(0.1)
        #  socket.emit :unread_conversation_count, {user_id: recipient.user_id, count: conversation_count}
        #  socket.emit :unread_conversation_ids, {
        #    'user_id' => recipient.user_id,
        #    'response' => {
        #      'conversation_ids' => conversation_ids,
        #      'last_message' => message,
        #      'conversation' => {
        #        id: conversation.id,
        #        name: conversation.name,
        #        last_message: conversation.last_message,
        #        last_user_id: conversation.last_user_id,
        #        updated_at: conversation.updated_at,
        #        read: false
        #        single_chat: !(conversation.sender_id.nil? && conversation.recipient_id.nil?),
        #        other_recipient_id: other_recipient_id,
        #        other_recipient_name: other_recipient_name,
        #        online_status: true
        #      }
        #    }
        #  }
        #end
        render json: message
      end

      api :PUT, 'conversations/:conversation_id/messages/:id.json', 'Update a chat message created by signed in user. chat: {message: <message>}'
      def update
        if @chat && @chat.update_attributes(chat_params)
          render json: @chat.to_json
        else
          error(E_INTERNAL, 'We were not able to update this message. Please try again.')
        end
      end

      api :DELETE, 'conversations/:conversation_id/messages/:id.json', 'Delete a chat message created by signed in user.'
      def destroy
        if @chat && @chat.destroy
          render json: @chat.to_json
        else
          error(E_INTERNAL, 'We were not able to delete this message. Please try again.')
        end
      end

      private

      def set_chat
        @chat = Chat.where(id: params[:id], from_user_id: current_user.id, conversation_id: params[:conversation_id]).first
      end
      def chat_params
        params.require(:chat).permit(:message)
      end
    end
  end
end
