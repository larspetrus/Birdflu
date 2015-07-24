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
    @db_query['oriented_corners'] = params[:co].to_i if params[:co].present?
    @db_query['edge_orientations']= params[:eo]      if params[:eo].present?
    @db_query['edge_positions']   = params[:ep]      if params[:ep].present?
    @db_query['is_mirror']        = false            if params[:im] == "No"
    @show_mirrors = (params[:im] == "No" ? "No" : "Yes")

    @positions = Position.includes(:best_alg).where(@db_query).to_a.sort_by! {|pos| pos.best_alg_length}

    sum = @positions.reduce(0.0) { |sum, pos| sum + pos.best_alg_length }
    @average = '%.2f' % (sum/@positions.count)

    @olls = OllIcons::ALL
    @cls_rows = CopIcons.grid
    @eos = EoIcons::ALL
    @eps_rows = EpIcons.grid
  end

  def show
    @position = Position.find_by(ll_code: params[:id])
    @cube = @position.as_cube
  end
end