class DemoController < ApplicationController
  def index
    @pos1 = Position.new(code: 'a1b1c1a1')
    @pos2 = Position.new(code: 'a1c3c3c5')
    @pos3 = Position.new(code: 'a3e6f1k4')

    # @pos1 = Position.new(code: 'a3e6f1k4')
    # @pos2 = Position.new(code: 'a4b7g2o1')
    # @pos3 = Position.new(code: 'b7g2o1a4')
    # @pos4 = Position.new(code: 'c8i7o2p5')


    #L' B' R B L B' R' B
    # @cube1.move(:L, 3)
    # @cube1.move(:B, 3)
    # @cube1.move(:R, 1)
    # @cube1.move(:B, 1)
    # @cube1.move(:L, 1)
    # @cube1.move(:B, 3)
    # @cube1.move(:R, 3)
    # @cube1.move(:B, 1)

    @cube1 = Cube.new()
    @cube1.move(:F, 1)
    @cube1.move(:U, 1)
    @cube1.move(:F, 3)
    @cube1.move(:U, 1)
    @cube1.move(:F, 1)
    @cube1.move(:U, 2)
    @cube1.move(:F, 3)
    @cube1.move(:U, 2)

    @cube2 = Cube.new()
    @cube2.move(:R, 3)
    @cube2.move(:F, 1)
    @cube2.move(:R, 1)
    @cube2.move(:F, 3)
    @cube2.move(:U, 3)
    @cube2.move(:F, 3)
    @cube2.move(:U, 1)
    @cube2.move(:F, 1)

    @cube3 = Cube.new()
    @cube3.move(:D, 1)
    @cube3.move(:R, 1)

    @cube4 = Cube.new()
    @cube4.move(:D, 1)
    @cube4.move(:L, 1)

  end
end
