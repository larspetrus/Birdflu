class OauthController < ActionController::Base
  CLIENT_ID = '7f190fdb8393613d534e2429d49c2cb897a3fe525bd2837edb48148de66fcf68'
  CLIENT_SECRET = 'e77f5ac2a1389e49c7f66bfca0491b8896e3974f05265909d61d2cf483fa2cee'

  TOKEN_URI = URI.parse("https://www.worldcubeassociation.org/oauth/token")
  ME_URI = URI.parse("https://www.worldcubeassociation.org/api/v0/me")

  def wca
    token_params = {
        code: params[:code],
        grant_type: 'authorization_code',
        redirect_uri: 'https://birdflu.lar5.com/wca_callback',
        client_id: CLIENT_ID,
        client_secret: CLIENT_SECRET,
    }
    token_response = Net::HTTP.post_form(TOKEN_URI, token_params)

    Rails.logger.info "Token response: #{token_response.body}"
    access_token = JSON.parse(token_response.body)["access_token"]

    if access_token
      me_request = Net::HTTP::Get.new(ME_URI.request_uri)
      me_request["Authorization"] = "Bearer #{access_token}"
      http = Net::HTTP.new(ME_URI.host, ME_URI.port)
      http.use_ssl = true
      me_data = JSON.parse(http.request(me_request).body)["me"]

      session[:wca_login] = {wca_id: me_data['wca_id'], name: me_data['name'], id: me_data['id']}

      Rails.logger.info "WCA Logged in as '#{me_data['name']}'."
    else
      Rails.logger.info "WCA Login failed."
    end

    redirect_to "/"
  end
end
