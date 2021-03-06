require 'rails_helper'

describe Api::V1::JobsController do

  describe 'when user is logged in' do
    let(:user) {create(:user)}
    before do
      auth_request user
    end

    describe 'GET #index' do
      it 'gets index page' do
        get :index, format: :json
        is_expected.to respond_with :ok
      end
    end

    describe 'GET #show' do
      it 'gets show page' do
        job = create(:job)
        get :show, id: job.id.to_i , format: :json
        is_expected.to respond_with :ok
      end
    end

    describe 'POST #create' do
      it 'land_manager can create a new job record' do
        auth_request create(:land_manager)
        post :create, job: attributes_for(:job, user_id: create(:project_manager).id, detail: 'Job description'), format: :json
        is_expected.to respond_with :ok
        expect(Job.count).to eq(1)
      end

      it 'project_manager cannot create a new job record' do
        auth_request create(:project_manager)
        post :create, job: attributes_for(:job, user_id: create(:user).id, detail: 'Job description'), format: :json
        is_expected.to respond_with 406
        expect(Job.count).to eq(0)
        expect(response.body).to match /Offering user must be a land_manager./
      end

      it 'land_manager cannot offer a job to another land_manager or themselves' do
        auth_request create(:land_manager)
        post :create, job: attributes_for(:job, user_id: create(:land_manager).id, detail: 'Job description'), format: :json
        is_expected.to respond_with 406
        expect(Job.count).to eq(0)
        expect(response.body).to match /Offered user must be project_manager./
      end
    end

    describe 'POST #update' do
      it 'land_manager can update a job record created by himself' do
        land_manager = create(:land_manager)
        job = create(:job, offered_by: land_manager)
        auth_request land_manager
        put :update, id: job.id, job: attributes_for(:job, detail: 'New Job description.'), format: :json
        is_expected.to respond_with :ok
      end

      it 'land_manager cannot update a job record not created by himself' do
        job = create(:job)
        auth_request create(:land_manager)
        put :update, id: job.id, job: attributes_for(:job, detail: ' New Job description'), format: :json
        is_expected.to respond_with(422)
        expect(response.body).to match /Job not found/
      end

    end

    describe 'DELETE #destroy' do
      it 'land_manager can delete a job created by himself' do
        land_manager = create(:land_manager)
        job = create(:job, offered_by: land_manager)
        auth_request land_manager
        delete :destroy, id: job.id, format: :json
        is_expected.to respond_with :ok
        expect(Job.count).to eq(0)
      end
      it 'land_manager can delete a job created by himself.' do
        land_manager = create(:land_manager)
        job = create(:job)
        auth_request land_manager
        delete :destroy, id: job.id, format: :json
        is_expected.to respond_with(422)
        expect(response.body).to match /Job cannot be deleted/
      end
    end


    #TODO find a way to add below tests to all controllers using shared contexts
    describe 'User has not accepted latest eula and privacy' do
      describe 'User has nil set in eula/privacy_id' do
        it 'should return 419 with depracted eula/privacy message' do
          user.update_attributes(eula_id: nil, privacy_id: nil)
          get :index, format: :json
          is_expected.to respond_with(419)
          expect(response.body).to match /"deprecated_eula":true/
          expect(response.body).to match /"deprecated_privacy":true/
        end
      end
      describe 'Latest eula gets updated' do
        it 'should return 419 with depracted eula message' do
          create(:eula)
          get :index, format: :json
          is_expected.to respond_with(419)
          expect(response.body).to match /"deprecated_eula":true/
          expect(response.body).to match /"deprecated_privacy":false/
        end
      end
      describe 'Latest eula gets updated' do
        it 'should return 419 with depracted eula message' do
          create(:privacy)
          get :index, format: :json
          is_expected.to respond_with(419)
          expect(response.body).to match /"deprecated_eula":false/
          expect(response.body).to match /"deprecated_privacy":true/
        end
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
      post :create, job: attributes_for(:job), format: :json
      is_expected.to respond_with(401)
    end

    it 'deletes a blocked user record' do
      delete :destroy, id: 99, format: :json
      is_expected.to respond_with(401)
    end

  end
end
