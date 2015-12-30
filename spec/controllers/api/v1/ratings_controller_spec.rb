require 'rails_helper'

describe Api::V1::RatingsController do

  describe 'when user is logged in' do
    let(:user) {create(:user)}

    before do
      sign_in user
    end

    describe 'GET #show' do
      it 'gets show page' do
        rating = create(:rating)
        get :show, id: rating.id.to_i , format: :json
        is_expected.to respond_with :ok
      end
    end

    describe 'POST #create' do
      it 'can create a new rating record' do
        post :create, rating: attributes_for(:rating, rated_on_id: create(:staff).id, rating: 1), format: :json
        is_expected.to respond_with :ok
        expect(Rating.last.rating).to eq(1)
      end
    end

    describe 'POST #update' do
      it 'can update a rating record' do
        rating = create(:rating)
        put :update, id: rating.id, rating: attributes_for(:rating, status: 1), format: :json
        is_expected.to respond_with :ok
      end
    end

  end

  describe 'when user is not logged in' do
    it 'returns 401 for show page' do
      get :show, id: 99 , format: :json
      is_expected.to respond_with(401)
    end

    it 'returns 401 for creating a new rating' do
      post :create, job: attributes_for(:job), format: :json
      is_expected.to respond_with(401)
    end

    it 'returns 401 for updating a rating' do
      put :update, id: 99, format: :json
      is_expected.to respond_with(401)
    end

  end
end
