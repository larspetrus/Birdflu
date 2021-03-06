# frozen_string_literal: true
require 'net/http'

class OauthController < ActionController::Base
  CLIENT_ID = '964462829fdba20e9da105d61499d8ce53d2f74dc31edbcd8d9c519fb98595bf'
  WCA_LOGIN_URL = "https://www.worldcubeassociation.org/oauth/authorize?response_type=code&client_id=#{OauthController::CLIENT_ID}&redirect_uri=https://birdflu.lar5.com/wca_callback&scope="

  TOKEN_URI = URI.parse("https://www.worldcubeassociation.org/oauth/token")
  ME_URI = URI.parse("https://www.worldcubeassociation.org/api/v0/me")

  # The WCA.org OAuth code redirects to here after user logs in
  def wca
    token_params = {
        code: params[:code],
        grant_type: 'authorization_code',
        redirect_uri: 'https://birdflu.lar5.com/wca_callback',
        client_id: CLIENT_ID,
        client_secret: Rails.application.secrets.wca_oauth_client_secret,
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

      store_login(me_data['id'], me_data['wca_id'], me_data['name'], 7.days.from_now.to_i)

      Rails.logger.info "WCA Logged in as '#{me_data['name']}'."
    else
      Rails.logger.info "WCA Login failed."
    end

    redirect_back(fallback_location: '/')
  end

  def fake_wca_login
    store_login(909, '2016FRAU99', 'Fakey McFraud', 4.hours.from_now.to_i)

    redirect_back(fallback_location: '/')
  end

  def wca_logout
    if session[:wca_login]
      Rails.logger.info "WCA Logged out '#{session[:wca_login]['name']}'."
      session.delete(:wca_login)
    else
      Rails.logger.warn "WCA Log out attempted with no one logged in."
    end

    redirect_back(fallback_location: '/')
  end

  def store_login(id, wca_id, name, expires)
    local_db_id = WcaUser.create_or_update(id, wca_id, name)
    session[:wca_login] = { db_id: local_db_id, wca_db_id: id, wca_id: wca_id, name: name, expires: expires }
  end
end
