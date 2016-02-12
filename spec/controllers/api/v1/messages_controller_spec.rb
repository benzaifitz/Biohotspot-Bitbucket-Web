require 'rails_helper'

describe Api::V1::MessagesController do
  render_views
  describe 'when user is logged in' do
    let(:user) {create(:user)}
    let(:conversation) {create(:conversation, from_user_id: user.id)}
    before do
      auth_request user
      add_rpush_app
    end

    describe 'GET #index' do
      it 'gets index page' do
        3.times { create(:chat, from_user_id: user.id, conversation_id: conversation.id, message: "Test Message") }
        get :index, conversation_id: conversation.id, format: :json
        is_expected.to respond_with :ok
        expect(response.body).to match /Test Message/
      end
    end

    describe 'POST #create' do
      let(:send_to_user) { create(:user)}
      it 'creates a new chat record in the corresponding conversation_id' do
        post :create, conversation_id: conversation.id, chat: attributes_for(:chat), format: :json
        is_expected.to respond_with :ok
        expect(Chat.count).to eq(1)
        expect(Chat.first.from_user_id).to eq(user.id)
      end

      it 'cannot create a new chat record if conversation was abandoned by one of the parties.' do
        post :create, conversation_id: conversation.id, chat: attributes_for(:chat), format: :json
        is_expected.to respond_with :ok
        conversation = Conversation.last
        DeletedConversation.create(user_id: conversation.user_id, conversation_id: conversation.id)
        post :create, conversation_id: conversation.id, chat: attributes_for(:conversation), format: :json
        expect(response.body).to match /could not be sent as this conversation was abandoned./
        expect(response.status).to match 406
      end

    end

    describe 'PUT #update' do
      it 'creates a new chat record in the corresponding conversation_id' do
        post :create, conversation_id: conversation.id, chat: attributes_for(:chat), format: :json
        is_expected.to respond_with :ok
        put :update, conversation_id: conversation.id, id: Chat.last.id, chat: {message: "Test30"}, format: :json
        is_expected.to respond_with :ok
        expect(response.body).to match /Test30/
      end
    end

    describe 'DELETE #delete' do
      let(:send_to_user) { create(:user)}
      it 'creates a new chat record in the corresponding conversation_id' do
        post :create, conversation_id: conversation.id, chat: attributes_for(:chat), format: :json
        is_expected.to respond_with :ok
        expect(Chat.count).to eq(1)
        delete :destroy, conversation_id: conversation.id, id: Chat.last.id, format: :json
        is_expected.to respond_with :ok
      end
    end
  end

  describe 'when user is not logged in' do
    it 'returns 401 for index page' do
      get :index, conversation_id: 1, format: :json
      is_expected.to respond_with(401)
    end

    it 'returns 401 on creating a chat' do
      post :create, conversation_id: 1, chat: attributes_for(:chat), format: :json
      is_expected.to respond_with(401)
    end
  end
end
