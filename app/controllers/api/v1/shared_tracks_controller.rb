module Api
  module V1
    class SharedTracksController < ApiController


      #POST /
      api :POST, '/shared_track.json'
      param :service_name, String
      def create
        byebug
        redis = Redis.new(:host => "localhost", :port => 6379, :db => 15)
        redis.set("shared_track", {service_name: params[:service_name], data: params[:data]}.to_json)
        render json: {success: true}
      end

      api :GET, '/shared_track.json'
      def index
        redis = Redis.new(:host => "localhost", :port => 6379, :db => 15)
        data = redis.get("shared_track")
        render json: {success: true, data: JSON.parse(data)}
      end

    end
  end
end
