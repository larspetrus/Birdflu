class PositionsController < ApplicationController
  def index
    BigThought.populate_db params[:force_db]
    @positions = Position.order(:ll_code)
  end

  def show
    @position = Position.find(params[:id])
    @cube = @position.as_cube
  end
end