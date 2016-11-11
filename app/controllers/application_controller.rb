# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :handle_wca_login

  def handle_wca_login
    if session[:wca_login]
      if Time.now.to_i > (session[:wca_login]['expires'] || 0)
        flash[:notification] = 'WCA login expired'
        session.delete(:wca_login)
      else
        sn = session[:wca_login]
        @login = OpenStruct.new(name: sn['name'], db_id: sn['db_id'])
      end
    end
  end
end
