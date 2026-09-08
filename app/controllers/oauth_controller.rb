# frozen_string_literal: true
require 'net/http'

class OauthController < ActionController::Base
  CLIENT_ID = '964462829fdba20e9da105d61499d8ce53d2f74dc31edbcd8d9c519fb98595bf'

  TOKEN_URI = URI.parse("https://www.worldcubeassociation.org/oauth/token")
  ME_URI = URI.parse("https://www.worldcubeassociation.org/api/v0/me")

  # Builds the WCA login link with a fresh anti-CSRF state token, stored in the visitor's session
  # so #wca can confirm the callback belongs to the same browser that started the login.
  def self.login_url(session)
    state = SecureRandom.hex(16)
    session[:wca_oauth_state] = state
    "https://www.worldcubeassociation.org/oauth/authorize?response_type=code&client_id=#{CLIENT_ID}&redirect_uri=https://birdflu.lar5.com/wca_callback&scope=&state=#{state}"
  end

  # The WCA.org OAuth code redirects to here after a user logs in
  def wca
    expected_state = session.delete(:wca_oauth_state)
    if params[:state].blank? || params[:state] != expected_state
      Rails.logger.warn "WCA Login failed: state mismatch."
      redirect_back(fallback_location: '/') and return
    end

    token_params = {
        code: params[:code],
        grant_type: 'authorization_code',
        redirect_uri: 'https://birdflu.lar5.com/wca_callback',
        client_id: CLIENT_ID,
        client_secret: ENV['WCA_OAUTH_CLIENT_SECRET'],
    }
    token_response = Net::HTTP.post_form(TOKEN_URI, token_params)

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
    raise ActionController::RoutingError, 'Not Found' unless Rails.env.development?

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
