class PositionsController < ApplicationController
  def index
    BigThought.populate_db
    @positions = Position.all
  end

  def show
    @position = Position.find(params[:id])
  end
end