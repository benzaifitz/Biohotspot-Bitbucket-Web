require 'rails_helper'

describe Api::V1::ReportedRatingsController do

  describe 'when user is logged in' do
    let(:user) {create(:user)}

    before do
      auth_request user
    end

    describe 'GET #show' do
      it 'gets show page' do
        reported_rating = create(:reported_rating)
        get :show, id: reported_rating.id , format: :json
        is_expected.to respond_with :ok
      end
    end

    describe 'POST #create' do
      it 'can create a new reported rating record' do
        post :create, reported_rating: attributes_for(:reported_rating, rating_id: create(:rating).id), format: :json
        is_expected.to respond_with :ok
        expect(ReportedRating.count).to eq(1)
      end
    end

  end

  describe 'when user is not logged in' do
    it 'returns 401 for show page' do
      get :show, id: 99 , format: :json
      is_expected.to respond_with(401)
    end

    it 'returns 401 for creating a new reported rating' do
      post :create, reported_rating: attributes_for(:reported_rating), format: :json
      is_expected.to respond_with(401)
    end

  end
end
