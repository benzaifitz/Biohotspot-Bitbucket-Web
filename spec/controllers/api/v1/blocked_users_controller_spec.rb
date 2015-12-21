require 'rails_helper'

describe Api::V1::BlockedUsersController do
  describe 'GET #index' do
    context 'when user is logged in' do
      let(:user) {create(:user)}
      before do
        sign_in user
        get :index, format: :json
      end
      it { is_expected.to respond_with :ok }
    end
    context 'when user is logged out' do
      before do
        get :index, format: :json
      end
      it { is_expected.to respond_with(401) }
    end
  end

  describe 'GET #show' do
    context 'when user is logged in' do
      let(:user) {create(:user)}
      before do
        sign_in user
        blocked_user = create(:blocked_user)
        get :show, id: blocked_user.id.to_i , format: :json
      end
      it { is_expected.to respond_with :ok }
    end
    context 'when user is logged out' do
      before do
        get :show, id: 111, format: :json
      end
      it { is_expected.to respond_with(401) }
    end
  end

  describe 'POST #create' do
    context 'when user is logged in' do
      let(:user) {create(:user)}
      before do
        sign_in user
        post :create, blocked_user: attributes_for(:blocked_user, user_id: create(:user).id), format: :json
      end
      it { is_expected.to respond_with :ok }
      it { expect(BlockedUser.count).to eq(1) }
    end
    context 'when user is logged out' do
      before do
        post :create, blocked_user: attributes_for(:blocked_user), format: :json
      end
      it { is_expected.to respond_with(401) }
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is logged in' do
      let(:user) {create(:user)}
      before do
        user_to_be_blocked = create(:user)
        blocked_user = create(:blocked_user, user_id: user_to_be_blocked.id, blocked_by_id: user.id)
        expect(BlockedUser.count).to eq(1)
        sign_in user
        delete :destroy, blocked_user: attributes_for(:blocked_user, user_id: blocked_user.user_id), format: :json
      end
      it { is_expected.to respond_with :ok }
      it { expect(BlockedUser.count).to eq(0) }
    end
    context 'when user is logged out' do
      before do
        delete :destroy, blocked_user: attributes_for(:blocked_user, user_id: create(:user).id), format: :json
      end
      it { is_expected.to respond_with(401) }
    end
  end

end
