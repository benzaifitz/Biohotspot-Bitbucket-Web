require 'rails_helper'

describe Api::V1::BlockedUsersController do

  describe 'when user is logged in' do
    let(:user) {create(:user)}
    before do
      sign_in user
    end

    describe 'GET #index' do
      it 'gets index page' do
        get :index, format: :json
        is_expected.to respond_with :ok
      end
    end

    describe 'GET #show' do
      it 'gets show page' do
        blocked_user = create(:blocked_user)
        get :show, id: blocked_user.id.to_i , format: :json
        is_expected.to respond_with :ok
      end
    end

    describe 'POST #create' do
      it 'creates a new blocked user record' do
        post :create, blocked_user: attributes_for(:blocked_user, user_id: create(:user).id), format: :json
        is_expected.to respond_with :ok
        expect(BlockedUser.count).to eq(1)
      end
    end

    describe 'DELETE #destroy' do
      it 'deletes a blocked user record' do
        user_to_be_blocked = create(:user)
        blocked_user = create(:blocked_user, user_id: user_to_be_blocked.id, blocked_by_id: user.id)
        expect(BlockedUser.count).to eq(1)
        delete :destroy, blocked_user: attributes_for(:blocked_user, user_id: blocked_user.user_id), format: :json
        is_expected.to respond_with :ok
        expect(BlockedUser.count).to eq(0)
      end
    end
  end

  describe 'when user is not logged in' do
    it 'returns 401 for index page' do
      get :index, format: :json
      is_expected.to respond_with(401)
    end

    it 'returns 401 for show page' do
      get :show, id: 99 , format: :json
      is_expected.to respond_with(401)
    end

    it 'creates a new blocked user record' do
      post :create, blocked_user: attributes_for(:blocked_user), format: :json
      is_expected.to respond_with(401)
    end

    it 'deletes a blocked user record' do
      delete :destroy, blocked_user: attributes_for(:blocked_user), format: :json
      is_expected.to respond_with(401)
    end

  end
end
