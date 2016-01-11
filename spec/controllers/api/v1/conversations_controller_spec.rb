require 'rails_helper'

describe Api::V1::ConversationsController do
  render_views
  describe 'when user is logged in' do
    let(:user) {create(:user)}
    before do
      auth_request user
    end

    describe 'GET #index' do
      it 'gets index page' do
        create(:conversation, from_user: user)
        get :index, format: :json
        is_expected.to respond_with :ok
      end
    end

    describe 'POST #create' do
      let(:send_to_user) { create(:user)}
      it 'creates a new conversation record' do
        post :create, conversation: attributes_for(:conversation, user_id: send_to_user.id), format: :json
        is_expected.to respond_with :ok
        expect(Conversation.count).to eq(1)
      end

      it 'cannot create a new conversation involving same two users' do
        post :create, conversation: attributes_for(:conversation, user_id: send_to_user.id), format: :json
        is_expected.to respond_with :ok
        post :create, conversation: attributes_for(:conversation, user_id: send_to_user.id), format: :json
        is_expected.to respond_with 500
        expect(Conversation.count).to eq(1)
      end
    end
  end

  describe 'when user is not logged in' do
    it 'returns 401 for index page' do
      get :index, format: :json
      is_expected.to respond_with(401)
    end

    it 'creates a new conversation record' do
      post :create, conversation: attributes_for(:conversation), format: :json
      is_expected.to respond_with(401)
    end
  end
end
