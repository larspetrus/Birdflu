# frozen_string_literal: true

class GalaxiesController < ApplicationController
  def index
    redirect_to('/') unless @login

    setup_leftbar
    @columns = Column.named([:hl_position, :name, :cop, :eop, :alg, :stars, :remove_star])
    @stars = Star.where(galaxies: {wca_user_id: @login&.db_id}).order(['galaxies.style', 'raw_algs.id']).includes(:raw_alg, :galaxy).to_a
    @per_style = @stars.chunk{ |line| line.galaxy.style }.to_a
    @list_classes = "galaxy-list size-#{@text_size}-wc"
    @rendered_svg_ids = Set.new
  end

  def update_star
    raise "Must be logged in to update stars" unless @login

    style = params[:star_class][4..-1].to_i # Format assumed to be "star#{style}"
    galaxy = Galaxy.find_or_create_by(wca_user_id: @login.db_id, style: style)
    alg_id = params[:rawalg_id].to_i
    galaxy.toggle(alg_id)

    render json: Galaxy.star_styles_for(@login.db_id, alg_id)
  end


  def remove_star
    raise 'Must be logged in' unless @login

    galaxy = Galaxy.find(params[:galaxy_id])
    raise 'Star removal failed' unless galaxy.wca_user_id == @login.db_id

    death_star = Star.find_by(galaxy_id: galaxy.id, raw_alg_id: params[:raw_alg_id])

    flash[:success] = "Star removed"
    death_star.destroy
    redirect_to(:back)
  end
end
