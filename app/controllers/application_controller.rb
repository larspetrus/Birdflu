# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :handle_wca_login, :allow_combos
  around_action :keep_track

  MAIN_NAME = 'Main'
  FAV_NAME = 'Favorites'
  ALGSETS_NAME = 'Combos'
  FMC_NAME = 'FMC'

  private

  def setup_leftbar
    @text_size = cookies[:size] || 'm'
    @position_set = cookies[:zbll] ?  'eo' : 'all'
    @list_format = Fields.read_list_format(cookies)
    @lb_sections = [MAIN_NAME, FAV_NAME] + (@show_combos ? [ALGSETS_NAME]: []) + [FMC_NAME]
    @lb_disabled = @login ? '' : FAV_NAME
  end

  def use_svgs
    @rendered_svg_ids = Set.new
  end

  @@request_count = Hash.new(0)
  @@trouble_list = []

  def handle_wca_login
    if session[:wca_login]
      if Time.now.to_i > (session[:wca_login]['expires'] || 0)
        flash.now[:notification] = 'WCA login expired'
        session.delete(:wca_login)
      else
        sn = session[:wca_login]
        @login = OpenStruct.new(name: sn['name'], db_id: sn['db_id'], wca_id: sn['wca_id'])
      end
    end
  end

  def allow_combos
    allowed_people = %w(1982PETR01 2005FLEI01)
    @show_combos = Rails.env.development? || allowed_people.include?(@login&.wca_id)
  end

  def keep_track
    @@request_count["#{params[:controller]}::#{params[:action]}"] += 1
    yield
  rescue Exception => e
    @@trouble_list << "Exception at #{Time.now} --- #{e.message}"
    raise
  end
end
