class PositionsController < ApplicationController
  CP_ENUM = Position.corner_swaps

  def index
    @db_query = {}
    @oll_options = (0..57).map { |n| "m#{n}" }

    @cp_param = params[:cp]
    @db_query['corner_swap'] = CP_ENUM['no'] if @cp_param == 'None'
    @db_query['corner_swap'] = CP_ENUM['diagonal'] if @cp_param == 'Diagonal'
    @db_query['corner_swap'] = [CP_ENUM['left'], CP_ENUM['right'], CP_ENUM['front'], CP_ENUM['back']] if @cp_param == 'Adjacent'

    @db_query['oll']              = params[:ol]      if params[:ol].present?
    @db_query['corner_look']      = params[:cl]      if params[:cl].present?
    @db_query['edge_orientations']= params[:eo]      if params[:eo].present?
    @db_query['edge_positions']   = params[:ep]      if params[:ep].present?
    @db_query['is_mirror']        = false            if params[:im] == "No"
    @show_mirrors = (params[:im] == "No" ? "No" : "Yes")

    @positions = Position.includes(:best_alg, :best_combo_alg).where(@db_query).to_a.sort_by! {|pos| pos.best_alg_length}
    @position_count = @positions.count

    optimal_sum = @positions.reduce(0.0) { |sum, pos| sum + pos.best_alg_length }
    @optimal_average = '%.2f' % (optimal_sum/@positions.count)

    combo_sum = @positions.reduce(0.0) { |sum, pos| sum + pos.best_combo_alg_length }
    @combo_average = '%.2f' % (combo_sum/@positions.count)

    @positions = @positions.first(100)


    @oll_selected = Icons::Oll.by_code(params[:ol])
    @cop_selected = Icons::Cop.by_code(params[:cl])
    @eo_selected  = Icons::Eo.by_code(params[:eo])
    @ep_selected  = Icons::Ep.by_code(params[:ep])

    @oll_rows = Icons::Oll::grid
    @cop_rows = Icons::Cop.grid
    @eo_rows = Icons::Eo::grid
    @ep_rows = Icons::Ep.grid

    @combos = [ComboAlg.where('base_alg2_id is not null').count, ComboAlg.count]

    @joke_header = ['Grail Moth', 'Oral Might', 'A Girl Moth', 'Ham To Girl', 'Roam Light', 'Mortal Sigh', 'A Grim Sloth', 'Glamor Shit', 'Solar Might'].sample
  end

  def show
    @position = Position.find_by(ll_code: params[:id])
    @top_3 = @position.top_3
    @cube = @position.as_cube
  end
end