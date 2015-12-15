module Api
  module V1
    class PrivaciesController < ApplicationController

      # GET /api/v1/privacy/latest.json
      def latest
        @privacy = Privacy.find_by_is_latest(true)
      end
    end
  end
end

