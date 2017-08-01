require 'rails_helper'

describe Api::V1::StaffsController do

  describe 'when user is logged in' do
    let(:project_manager) {create(:project_manager)}
    before do
      auth_request project_manager
    end

    describe 'GET #show' do
      it 'gets show page' do
        project_manager = create(:project_manager)
        get :show, id: project_manager.id , format: :json
        is_expected.to respond_with :ok
      end
    end

    describe 'PUT #update' do
      it 'updates currently logged in project_manager record' do
        put :update, id: project_manager.id, project_manager: {first_name: 'New First Name'}, format: :json
        is_expected.to respond_with :ok
        project_manager.reload
        expect(project_manager.first_name).to eq('New First Name')
      end

      it 'updates currently logged in staffs profile picture' do
        uri = URI("http://cdn4.iconfinder.com/data/icons/small-n-flat/24/calendar-128.png")
        data = Base64.encode64 Net::HTTP.get(uri)
        put :update, id: project_manager.id, project_manager: {image_data: data, image_type: 'image/png'}, format: :json
        is_expected.to respond_with :ok
        project_manager.reload
        expect(project_manager.profile_picture_url).to_not eq nil
        project_manager.remove_profile_picture = true
        project_manager.save
        expect(project_manager.profile_picture.url).to eq nil
      end

      it 'does not update non logged in project_manager' do
        not_logged_staff = create(:project_manager, first_name: 'not_logged_in_first_name')
        put :update, id: not_logged_staff.id, project_manager: {first_name: 'New First Name'}, format: :json
        is_expected.to respond_with 406
        not_logged_staff.reload
        expect(not_logged_staff.first_name).to eq('not_logged_in_first_name')
        expect(response.body).to match /Update not allowed/
      end
    end
  end

  describe 'when user is not logged in' do

    it 'returns 401 for show page' do
      get :show, id: 99 , format: :json
      is_expected.to respond_with(401)
    end

    it 'returns 401 for project_manager update' do
      put :update, id: 99, format: :json
      is_expected.to respond_with(401)
    end
  end
end
