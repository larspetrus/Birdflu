class PositionsController < ApplicationController
  CP_ENUM = Position.corner_swaps

  def index
    @query = {}
    @oll_options = (0..57).map { |n| "m#{n}" }

    @cp_param = params[:cp]
    @query['corner_swap'] = CP_ENUM['no'] if @cp_param == 'None'
    @query['corner_swap'] = CP_ENUM['diagonal'] if @cp_param == 'Diagonal'
    @query['corner_swap'] = [CP_ENUM['left'], CP_ENUM['right'], CP_ENUM['front'], CP_ENUM['back']] if @cp_param == 'Adjacent'

    @query['oll']              = params[:ol]      if params[:ol].present?
    @query['corner_look']      = params[:cl]      if params[:cl].present?
    @query['oriented_corners'] = params[:co].to_i if params[:co].present?
    @query['oriented_edges']   = params[:eo].to_i if params[:eo].present?
    @query['is_mirror']        = false            if params[:im] == "No"
    @show_mirrors = (params[:im] == "No" ? "No" : "Yes")

    @positions = Position.includes(:best_alg).where(@query).to_a.sort_by! {|pos| pos.best_alg_length}

    sum = @positions.reduce(0.0) { |sum, pos| sum + pos.best_alg_length }
    @average = '%.2f' % (sum/@positions.count)

    @olls = OllPosition::ALL
    @cls = CornerPosition::ALL
  end

  def show
    @position = Position.find_by(ll_code: params[:id])
    @cube = @position.as_cube
  end
end