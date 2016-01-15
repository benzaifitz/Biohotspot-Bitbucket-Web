require 'rails_helper'

describe Api::V1::CustomersController do
  render_views
  describe 'when customer is logged in' do
    let(:customer) {create(:customer)}
    before do
      auth_request customer
    end

    describe 'GET #show' do
      it 'gets show page' do
        customer = create(:customer)
        get :show, id: customer.id , format: :json
        is_expected.to respond_with :ok
      end
    end

    describe 'PUT #update' do
      it 'updates currently logged in customer record' do
        put :update, id: customer.id, customer: {first_name: 'New First Name'}, format: :json
        is_expected.to respond_with :ok
        customer.reload
        expect(customer.first_name).to eq('New First Name')
      end


      it 'does not update non logged in customer' do
        not_logged_customer = create(:customer, first_name: 'not_logged_in_first_name')
        put :update, id: not_logged_customer.id, customer: {first_name: 'New First Name'}, format: :json
        is_expected.to respond_with 500
        customer.reload
        expect(not_logged_customer.first_name).to eq('not_logged_in_first_name')
        expect(response.body).to match /Update not allowed/
      end
    end

    describe 'PUT #update_profile_picture' do
      it 'updates currently logged in customers profile picture' do
        uri = URI("http://cdn4.iconfinder.com/data/icons/small-n-flat/24/calendar-128.png")
        data = Base64.encode64 Net::HTTP.get(uri)
        put :update_profile_picture, customer_id: customer.id, customer: {image_data: data, image_extension: 'png', image_type: 'image/png', image_name: 'customer_image'}, format: :json
        is_expected.to respond_with :ok
        expect(response.body).to match /profile_picture_url/
        customer.remove_profile_picture = true
        customer.save
        expect(customer.profile_picture_url).to eq nil
      end
    end

  end

  describe 'when customer is not logged in' do

    it 'returns 401 for show page' do
      get :show, id: 99 , format: :json
      is_expected.to respond_with(401)
    end

    it 'returns 401 for customer update' do
      put :update, id: 99, format: :json
      is_expected.to respond_with(401)
    end

    it 'returns 401 for customer profile picture update'  do
      put :update_profile_picture, customer_id: 99, format: :json
      is_expected.to respond_with(401)
    end
  end
end
