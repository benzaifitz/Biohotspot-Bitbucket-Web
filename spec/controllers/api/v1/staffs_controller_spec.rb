require 'rails_helper'

describe Api::V1::StaffsController do

  describe 'when user is logged in' do
    let(:staff) {create(:staff)}
    before do
      auth_request staff
    end

    describe 'GET #show' do
      it 'gets show page' do
        staff = create(:staff)
        get :show, id: staff.id , format: :json
        is_expected.to respond_with :ok
      end
    end

    describe 'PUT #update' do
      it 'updates currently logged in staff record' do
        put :update, id: staff.id, staff: {first_name: 'New First Name'}, format: :json
        is_expected.to respond_with :ok
        staff.reload
        expect(staff.first_name).to eq('New First Name')
      end

      it 'does not update non logged in staff' do
        not_logged_staff = create(:staff, first_name: 'not_logged_in_first_name')
        put :update, id: not_logged_staff.id, staff: {first_name: 'New First Name'}, format: :json
        is_expected.to respond_with 500
        not_logged_staff.reload
        expect(not_logged_staff.first_name).to eq('not_logged_in_first_name')
        expect(response.body).to match /Update not allowed/
      end
    end

    describe 'PUT #update_profile_picture' do
      it 'updates currently logged in staffs profile picture' do
        uri = URI("http://cdn4.iconfinder.com/data/icons/small-n-flat/24/calendar-128.png")
        data = Base64.encode64 Net::HTTP.get(uri)
        put :update_profile_picture, staff_id: staff.id, staff: {image_data: data, image_extension: 'png', image_type: 'image/png', image_name: 'customer_image'}, format: :json
        is_expected.to respond_with :ok
        expect(response.body).to match /profile_picture_url/
        staff.remove_profile_picture = true
        staff.save
        expect(staff.profile_picture_url).to eq nil
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

    it 'returns 401 for staff profile picture update'  do
      put :update_profile_picture, staff_id: 99, format: :json
      is_expected.to respond_with(401)
    end
  end
end
