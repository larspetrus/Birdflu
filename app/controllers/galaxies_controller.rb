# frozen_string_literal: true

class GalaxiesController < ApplicationController
  def index
    redirect_to('/') unless @login

    setup_leftbar
    @columns = Column.named([:name_link, :cop, :eop, :alg, :stars, :remove_star])
    @stars = Star.where(galaxies: {wca_user_id: @login&.db_id})
                 .order(['galaxies.starred_type DESC', 'galaxies.style'])
                 .includes(:galaxy) # can't get :starrable to work here :(
                 .to_a
    @per_style = @stars.chunk{ |line| line.galaxy.css_class }.to_a
    @list_classes = "galaxy-list size-#{@text_size}"
    @rendered_svg_ids = Set.new
  end

  def show
    raise "BANANA"
  end

  def update_star
    raise "Must be logged in to update stars" unless @login

    alg_type, style = Star.select_from_class(params[:star_class])
    galaxy = Galaxy.find_or_create_by(wca_user_id: @login.db_id, style: style, starred_type: alg_type)
    alg_id = params[:starred_id].to_i
    galaxy.toggle(alg_id)

    render json: Galaxy.star_styles_for(@login.db_id, alg_id, alg_type)
  end


  def remove_star
    raise 'Must be logged in' unless @login

    galaxy = Galaxy.find(params[:galaxy_id])
    raise 'Star removal failed' unless galaxy.wca_user_id == @login.db_id

    death_star = Star.find_by(galaxy_id: galaxy.id, starred_id: params[:starred_id])

    flash[:success] = "Star removed"
    death_star.destroy
    redirect_to(:back)
  end
end
