require 'rails_helper'

describe Api::V1::StaffsController do

  describe 'when user is logged in' do
    let(:user) {create(:user)}
    before do
      sign_in user
    end

    describe 'GET #show' do
      it 'gets show page' do
        staff = create(:staff)
        get :show, id: staff.id , format: :json
        is_expected.to respond_with :ok
      end
    end

    describe 'PUT #update' do
      it 'updates staff record' do
        put :update, id: user.id, staff: {first_name: 'New First Name'}, format: :json
        is_expected.to respond_with :ok
        user.reload
        expect(user.first_name).to eq('New First Name')
      end
    end

  end

  describe 'when user is not logged in' do

    it 'returns 401 for show page' do
      get :show, id: 99 , format: :json
      is_expected.to respond_with(401)
    end

    it 'returns 401 for staff update' do
      put :update, id: 99, format: :json
      is_expected.to respond_with(401)
    end

  end
end
