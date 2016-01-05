require 'rails_helper'

describe Api::V1::MessagesController do
  render_views
  describe 'when user is logged in' do
    let(:user) {create(:user)}
    let(:conversation) {create(:conversation)}
    before do
      sign_in user
    end

    describe 'GET #index' do
      it 'gets index page' do
        3.times { create(:chat, user_id: user.id, conversation_id: conversation.id) }
        get :index, conversation_id: 1, format: :json
        is_expected.to respond_with :ok
      end
    end

    describe 'POST #create' do
      let(:send_to_user) { create(:user)}
      it 'creates a new chat record in the corresponding conversation_id' do
        post :create, conversation_id: conversation.id, chat: attributes_for(:conversation, user_id: send_to_user.id, from_user_id: user.id), format: :json
        is_expected.to respond_with :ok
        expect(Chat.count).to eq(1)
        expect(Chat.first.from_user_id).to eq(user.id)
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
