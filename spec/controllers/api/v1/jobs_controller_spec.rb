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
      it 'customer can create a new job record' do
        auth_request create(:customer)
        post :create, job: attributes_for(:job, user_id: create(:staff).id, detail: 'Job description'), format: :json
        is_expected.to respond_with :ok
        expect(Job.count).to eq(1)
      end

      it 'staff cannot create a new job record' do
        auth_request create(:staff)
        post :create, job: attributes_for(:job, user_id: create(:user).id, detail: 'Job description'), format: :json
        is_expected.to respond_with 500
        expect(Job.count).to eq(0)
        expect(response.body).to match /Offering user must be a customer./
      end

      it 'customer cannot offer a job to another customer or themselves' do
        auth_request create(:customer)
        post :create, job: attributes_for(:job, user_id: create(:customer).id, detail: 'Job description'), format: :json
        is_expected.to respond_with 500
        expect(Job.count).to eq(0)
        expect(response.body).to match /Offered user must be staff./
      end
    end

    describe 'POST #update' do
      it 'customer can update a job record created by himself' do
        customer = create(:customer)
        job = create(:job, offered_by: customer)
        auth_request customer
        put :update, id: job.id, job: attributes_for(:job, detail: 'New Job description.'), format: :json
        is_expected.to respond_with :ok
      end

      it 'customer cannot update a job record not created by himself' do
        job = create(:job)
        auth_request create(:customer)
        put :update, id: job.id, job: attributes_for(:job, detail: ' New Job description'), format: :json
        is_expected.to respond_with(422)
        expect(response.body).to match /Job not found/
      end

    end

    describe 'DELETE #destroy' do
      it 'customer can delete a job created by himself' do
        customer = create(:customer)
        job = create(:job, offered_by: customer)
        auth_request customer
        delete :destroy, id: job.id, format: :json
        is_expected.to respond_with :ok
        expect(Job.count).to eq(0)
      end
      it 'customer can delete a job created by himself.' do
        customer = create(:customer)
        job = create(:job)
        auth_request customer
        delete :destroy, id: job.id, format: :json
        is_expected.to respond_with(422)
        expect(response.body).to match /Job cannot be deleted/
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
