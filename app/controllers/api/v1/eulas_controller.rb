module Api
  module V1
    class EulasController < ApiController

      # GET /api/v1/eula/latest.json
      api :GET, '/eula/latest.json', 'Returns the latest EULA.'
      def latest
        @eula = Eula.find_by_is_latest(true)
      end
    end
  end
end
