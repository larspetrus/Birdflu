class LlAlg
  attr_reader :name, :moves, :solves_ll_code

  def self.variants(name, moves)
    circle = {'R'=>'F', 'F'=>'L', 'L'=>'B', 'B'=>'R'}

    result = []
    4.times do
      result << LlAlg.new(name + "-#{moves.split(' ').first}", moves)
      moves = moves.chars.map { |char| circle[char] || char}.join
    end
    result
  end

  def initialize(name, moves)
    @name = name
    @moves = moves
    @solves_ll_code = Cube.new.setup_alg(moves).standard_ll_code
  end

  def to_s
    "#{@name}: #{@moves}"
  end
end
