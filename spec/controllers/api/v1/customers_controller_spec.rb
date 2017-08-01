require 'rails_helper'

describe Api::V1::CustomersController do
  render_views
  describe 'when land_manager is logged in' do
    let(:land_manager) {create(:land_manager)}
    before do
      auth_request land_manager
    end

    describe 'GET #show' do
      it 'gets show page' do
        land_manager = create(:land_manager)
        get :show, id: land_manager.id , format: :json
        is_expected.to respond_with :ok
      end
    end

    describe 'PUT #update' do
      it 'updates currently logged in land_manager record' do
        put :update, id: land_manager.id, land_manager: {first_name: 'New First Name'}, format: :json
        is_expected.to respond_with :ok
        land_manager.reload
        expect(land_manager.first_name).to eq('New First Name')
      end


      it 'does not update non logged in land_manager' do
        not_logged_customer = create(:land_manager, first_name: 'not_logged_in_first_name')
        put :update, id: not_logged_customer.id, land_manager: {first_name: 'New First Name'}, format: :json
        is_expected.to respond_with 406
        land_manager.reload
        expect(not_logged_customer.first_name).to eq('not_logged_in_first_name')
        expect(response.body).to match /Update not allowed/
      end
    end

    describe 'PUT #update_profile_picture' do
      it 'updates currently logged in customers profile picture' do
        uri = URI("http://cdn4.iconfinder.com/data/icons/small-n-flat/24/calendar-128.png")
        data = Base64.encode64 Net::HTTP.get(uri)
        put :update, id: land_manager.id, land_manager: {image_data: data, image_type: 'image/png'}, format: :json
        is_expected.to respond_with :ok
        land_manager.reload
        expect(land_manager.profile_picture_url).to_not eq nil
        land_manager.remove_profile_picture = true
        land_manager.save
        expect(land_manager.profile_picture.url).to eq nil
      end
    end

  end

  describe 'when land_manager is not logged in' do

    it 'returns 401 for show page' do
      get :show, id: 99 , format: :json
      is_expected.to respond_with(401)
    end

    it 'returns 401 for land_manager update' do
      put :update, id: 99, format: :json
      is_expected.to respond_with(401)
    end
  end
end
