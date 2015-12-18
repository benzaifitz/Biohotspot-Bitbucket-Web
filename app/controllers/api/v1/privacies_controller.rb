module Api
  module V1
    class PrivaciesController < ApplicationController

      # GET /api/v1/privacy/latest.json
      api :GET, '/privacy/latest.json', 'Returns the latest Privacy Policy.'
      def latest
        @privacy = Privacy.find_by_is_latest(true)
      end
    end
  end
end

