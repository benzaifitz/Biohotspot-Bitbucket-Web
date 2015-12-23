class Api::MessagesController < ApiController
  
  def create
    conversation = Conversation.find(params[:conversation_id])
    if conversation
      message = conversation.chats.create(chat_params)
      conversation.last_message = message[:body]
      conversation.last_user_id = message[:user_id]
      
      sender = User.find(message[:user_id])
      message_body = sender.name.capitalize + ' sent you a message'
      if conversation.user_id == sender.id
        recipient = conversation.from_user
      else
        recipient = conversation.user
      end
      recipient.user.push_notification_iphone(message_body)
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
  
  private
  
  def chat_params
    params.require(:chat).permit(:user_id, :message)
  end
end
