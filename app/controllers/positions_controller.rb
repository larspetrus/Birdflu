class PositionsController < ApplicationController
  def index
    BigThought.populate_db params[:force_db]

    @query = {}
    @query['oriented_corners'] = params[:co].to_i if params[:co].present?
    @query['oriented_edges'] = params[:eo].to_i if params[:eo].present?
    @positions = Position.includes(:best_alg).where(@query).order(:ll_code)
  end

  def show
    @position = Position.find(params[:id])
    @cube = @position.as_cube
  end
end