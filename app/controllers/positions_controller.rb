class PositionsController < ApplicationController
  CP_ENUM = Position.corner_swaps

  def index
    BigThought.populate_db

    @query = {}

    @cp_param = params[:cp]
    @query['corner_swap'] = CP_ENUM['no'] if @cp_param == 'None'
    @query['corner_swap'] = CP_ENUM['diagonal'] if @cp_param == 'Diagonal'
    @query['corner_swap'] = [CP_ENUM['left'], CP_ENUM['right'], CP_ENUM['front'], CP_ENUM['back']] if @cp_param == 'Adjacent'

    @query['corner_look']      = params[:cl]      if params[:cl].present?
    @query['oriented_corners'] = params[:co].to_i if params[:co].present?
    @query['oriented_edges']   = params[:eo].to_i if params[:eo].present?

    @positions = Position.includes(:best_alg).where(@query).order(:ll_code)
  end

  def show
    @position = Position.find_by(ll_code: params[:id])
    @cube = @position.as_cube
  end
end