class Move
  attr_reader :side, :turns, :name, :compressed_code

  TURN_CODES = [nil, "", "2", "'"]
  def self.name_from(side, turns)
    "#{side}#{TURN_CODES[turns]}"
  end


  def initialize(side, turns)
    raise "Attempt to create 19th move: Move.new(#{side}, #{turns})" if @@all_moves.size >= 18
    @side = side
    @turns = turns
    @name = Move.name_from(side, turns)
    compression_codes = {F: %w[- F f E], B: %w[- B b q], R: %w[- R r P], L: %w[- L l 1], U: %w[- U u n], D: %w[- D d p]}
    @compressed_code = compression_codes[side][turns]

    @@move_lookup[name] = self
    @@move_lookup[[side, turns]] = self
    @@move_lookup[@compressed_code] = self

    @@all_moves << self
  end

  @@move_lookup = {}
  @@all_moves = []

  R  = Move.new(:R, 1)
  R2 = Move.new(:R, 2)
  Rp = Move.new(:R, 3)
  L  = Move.new(:L, 1)
  L2 = Move.new(:L, 2)
  Lp = Move.new(:L, 3)
  U  = Move.new(:U, 1)
  U2 = Move.new(:U, 2)
  Up = Move.new(:U, 3)
  D  = Move.new(:D, 1)
  D2 = Move.new(:D, 2)
  Dp = Move.new(:D, 3)
  F  = Move.new(:F, 1)
  F2 = Move.new(:F, 2)
  Fp = Move.new(:F, 3)
  B  = Move.new(:B, 1)
  B2 = Move.new(:B, 2)
  Bp = Move.new(:B, 3)

  def self.[](key)
    @@move_lookup[key] || raise(%Q(Invalid move code: "#{key}"))
  end

  def self.same_side(move1, move2)
    return false if move1.nil? || move2.nil?
    move1[0] == move2[0]
  end

  OPPOSITE_SIDE = {'L'=>'R', 'R'=>'L', 'F'=>'B', 'B'=>'F', 'U'=>'D', 'D'=>'U'}
  def self.opposite_sides(move1, move2)
    move1.present? && move2.present? && move1[0] == OPPOSITE_SIDE[move2[0]]
  end

  def self.merge(move1, move2)
    turn_sum = (turns(move1) + turns(move2)) % 4
    turn_sum > 0 ? name_from(move1[0], turn_sum) : nil
  end

  def self.turns(move)
    {"2"=>2, "'"=>3}[move[1]] || 1
  end

  def inverse
    Move[[@side, 4-@turns]]
  end

end