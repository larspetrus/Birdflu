class LlAlg
  attr_reader :name, :moves, :primary, :solves_ll_code

  def initialize(name, moves, primary = false)
    @name = name
    @moves = moves
    @solves_ll_code = Cube.new.setup_alg(moves).standard_ll_code
    @primary = primary
  end

  def to_s
    "#{@name}: #{@moves}"
  end

  def length
    @moves.split(' ').length
  end

  def nl
    "#{length} #{name}"
  end
end
