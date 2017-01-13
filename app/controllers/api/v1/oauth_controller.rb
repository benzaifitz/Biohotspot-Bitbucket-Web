module Api
  module V1
    class OauthController < ApiController



      api :GET, '/oauth/authorize.json'
      param :platform, String, desc: 'ios or android'
      def authorize
        redirect_to "https://accounts.spotify.com/authorize" +
            '?response_type=code' +
            '&client_id=67bf0cd564964b6dae159a89adc4def1' +
            '&scope=playlist-read-private user-read-private user-read-email' +
            "&redirect_uri=http://#{Rails.env.development? ? "localhost:3000" : "13.55.66.234"}/api/v1/oauth/callback"+
            "&state="+params[:platform] || ""
      end

      def callback
        authorize_code = params[:code]
        if authorize_code
          response = get_tokens(authorize_code)

          if params["state"] == 'android'
            redirect_to "http://staging.audalize.com.au/outh-callback?access_token=#{response["access_token"]}&refresh_token=#{response["refresh_token"]}" and return
          elsif params["state"] == 'ios'
            redirect_to "spotifyiossdkexample://staging.audalize.com.au/outh-callback?access_token=#{response["access_token"]}&refresh_token=#{response["refresh_token"]}" and return
          end
        end
      end

      api :GET, '/oauth/spotify_refresh_token.json'
      param :refresh_token, String
      def spotify_refresh_token
        res = RestClient.post(end_point, {grant_type: "refresh_token", refresh_token: params[:refresh_token], client_id: '67bf0cd564964b6dae159a89adc4def1',  client_secret: 'd6bdd4c3d7354692bc87f1878e5dace4'})
        render json: JSON.parse(res)
      end


      def get_tokens(code)

        token_end_point = "https://accounts.spotify.com/api/token"
        grant_type = "authorization_code"
        response = RestClient.post(token_end_point, {grant_type: grant_type,
                                          code: code,
                                          redirect_uri: "http://#{Rails.env.development? ? "localhost:3000" : "13.55.66.234"}/api/v1/oauth/callback",
                                          client_id: '67bf0cd564964b6dae159a89adc4def1',
                                          client_secret: 'd6bdd4c3d7354692bc87f1878e5dace4'
                                          }
                                         )
        JSON.parse response
      end
    end
  end
end
