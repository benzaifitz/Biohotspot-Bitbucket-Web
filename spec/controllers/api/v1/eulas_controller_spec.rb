require 'rails_helper'

describe Api::V1::EulasController do

  describe 'when user is logged in' do
    describe 'GET #latest' do
      it 'gets latest eula' do
        get :latest, format: :json
        is_expected.to respond_with :ok
      end
    end

  end
end
