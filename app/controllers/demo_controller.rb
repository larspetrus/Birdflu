class DemoController < ApplicationController
  def index
    BigThought.populate_db
    @cube1 = Cube.new().setup_alg("F U F' U F U2 F' U2")
  end

end
