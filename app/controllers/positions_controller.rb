class PositionsController < ApplicationController
  CP_ENUM = Position.corner_swaps

  def index
    BigThought.populate_base_algs

    @query = {}

    @pcp = params[:cp]
    @query['corner_swap'] = CP_ENUM['no'] if @pcp == 'None'
    @query['corner_swap'] = CP_ENUM['diagonal'] if @pcp == 'Diagonal'
    @query['corner_swap'] = [CP_ENUM['left'], CP_ENUM['right'], CP_ENUM['front'], CP_ENUM['back']] if @pcp == 'Adjacent'

    @query['oriented_corners'] = params[:co].to_i if params[:co].present?
    @query['oriented_edges'] = params[:eo].to_i if params[:eo].present?

    @positions = Position.includes(:best_alg).where(@query).order(:ll_code)
  end

  def show
    @position = Position.find_by(ll_code: params[:id])
    @cube = @position.as_cube
  end
end