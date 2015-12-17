module Api
  module V1
    class EulasController < ApiController
      before_action :authenticate_user!

      # GET /api/v1/eula/latest.json
      def latest
        @eula = Eula.find_by_is_latest(true)
      end
    end
  end
end
