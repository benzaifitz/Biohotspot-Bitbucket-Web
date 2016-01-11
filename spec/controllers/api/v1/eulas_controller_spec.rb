require 'rails_helper'

describe Api::V1::EulasController do

  describe 'when user is logged in' do
    let(:user) {create(:user)}
    before do
      auth_request user
    end

    describe 'GET #latest' do
      it 'gets latest eula' do
        get :latest, format: :json
        is_expected.to respond_with :ok
      end
    end

  end

  describe 'when user is not logged in' do

    it 'returns 401 for latest eula' do
      get :latest, format: :json
      is_expected.to respond_with(401)
    end

  end
end
