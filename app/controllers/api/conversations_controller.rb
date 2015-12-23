class Api::ConversationsController < ApiController
  before_action :authenticate_user!
  respond_to :json
  
  def index
    @conversations = Conversation.all
    respond_with @conversations
  end
end
