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
      it 'creates a new direct conversation record' do
        post :create, conversation: attributes_for(:conversation, user_id: send_to_user.id, contersation_type: 0), format: :json
        is_expected.to respond_with :ok
        expect(Conversation.count).to eq(1)
      end

      it 'creates a new community conversation record' do
        post :create, conversation: attributes_for(:conversation, user_id: send_to_user.id, contersation_type: 1), format: :json
        is_expected.to respond_with :ok
        expect(Conversation.count).to eq(1)
      end

      it 'cannot create a new direct conversation record without user_id' do
        post :create, conversation: attributes_for(:conversation, user_id: nil), format: :json
        is_expected.to respond_with 406
        expect(Conversation.count).to eq(0)
      end

      it 'cannot returns the already created conversation on create call for two users' do
        post :create, conversation: attributes_for(:conversation, user_id: send_to_user.id), format: :json
        is_expected.to respond_with :ok
        post :create, conversation: attributes_for(:conversation, user_id: send_to_user.id), format: :json
        is_expected.to respond_with 200
        expect(Conversation.count).to eq(1)
      end


    end

    describe 'PUT #add_participants' do
      it 'adds participants to a community conversation' do
        post :create, conversation: attributes_for(:conversation, user_id: nil, conversation_type: Conversation.conversation_types[:community]), format: :json
        is_expected.to respond_with :ok
        users = []
        3.times do
          users << create(:user)
        end
        users << Conversation.first.from_user
        put :add_participants, conversation_id: Conversation.first.id, participant_ids: users.map(&:id).join(','), format: :json
        is_expected.to respond_with :ok
        expect(Conversation.first.conversation_participants.count).to eq(4)
      end

      it 'cannot adds participants to a direct conversation' do
        post :create, conversation: attributes_for(:conversation, user_id: create(:user).id, conversation_type: Conversation.conversation_types[:direct]), format: :json
        is_expected.to respond_with :ok
        put :add_participants, conversation_id: Conversation.first.id, participant_ids: Conversation.first.from_user_id.to_s, format: :json
        is_expected.to respond_with 406
      end
    end
  end

  describe 'when user is not logged in' do
    it 'returns 401 for index page' do
      get :index, format: :json
      is_expected.to respond_with(401)
    end

    it 'returns 401 for create' do
      post :create, conversation: attributes_for(:conversation), format: :json
      is_expected.to respond_with(401)
    end

    it 'returns 401 for add_index' do
      put :add_participants, conversation_id: 1, participant_ids: "1,2", format: :json
      is_expected.to respond_with(401)
    end
  end
end
