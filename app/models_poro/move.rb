# frozen_string_literal: true

class Move # The classic BRDFLU "cube moves"
  attr_reader :side, :turns, :name, :pack_code

  TURN_CODES = [nil, "", "2", "'"]

  def self.name_from(side, turns)
    "#{side}#{TURN_CODES[turns]}"
  end

  def initialize(side, turns)
    raise "Attempt to create 19th move: Move.new(#{side}, #{turns})" if @@all_moves.size >= 18

    @side = side
    @turns = turns
    @name = Move.name_from(side, turns)
    pack_codes = { F: %w[- F f E], B: %w[- B b q], R: %w[- R r P], L: %w[- L l 1], U: %w[- U u n], D: %w[- D d p] }
    @pack_code = pack_codes[side][turns]

    @@move_lookup[name] = @@move_lookup[[side, turns]] = @@move_lookup[@pack_code] = self

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

  OPPOSITE_SIDE = { 'L' => 'R', 'R' => 'L', 'F' => 'B', 'B' => 'F', 'U' => 'D', 'D' => 'U' }

  def self.opposite_sides(move1, move2)
    move1.present? && move2.present? && move1[0] == OPPOSITE_SIDE[move2[0]]
  end

  def self.merge(move1, move2)
    turn_sum = (turns(move1) + turns(move2)) % 4
    turn_sum > 0 ? name_from(move1[0], turn_sum) : nil
  end

  def self.turns(move)
    {nil => 1, "2" => 2, "'" => 3 }[move[1]]
  end

  def inverse
    Move[[@side, 4 - @turns]]
  end

end

# Tracks where the physical sides of a cube are during a Hand Move sequence
class SideTracker
  CIRCLES = { "x" => "FUBD", "y" => "FLBR", "z" => "URDL" }.freeze # "x" moves F->U, U->B, etc

  def initialize
    @side_at = { 'R' => 'R', 'L' => 'L', 'U' => 'U', 'D' => 'D', 'F' => 'F', 'B' => 'B' } # tracks where sides are
  end

  def track(move)
    move_side = move[0]
    if (sc = CIRCLES[move_side]) # Is this a cube rotation move?
      new_sides = [@side_at[sc[0]], @side_at[sc[1]], @side_at[sc[2]], @side_at[sc[3]]].rotate(Move.turns(move))
      sc.chars.zip(new_sides).each { |key, value| @side_at[key] = value }

      nil # No real BRDFLU move happened
    else
      @side_at.key(move_side) # return the BRDFLU side that was turned
    end
  end

  # Clean up/optimize the moves so we don't get silliness like L R L
  # Note that there is also an Algs::normalize() Could maybe share code??
  def self.normalize(alg)
    moves = DuAlg.new(alg, MoveSet::BRDFLU).as_list
    nil while self._improve(moves)  # The while needs something to do, even if it's nil
    DuAlg.new(moves)
  end

  # It's hard to fully normalize moves in one sweep, so the caller should call ._improve() until it returns False
  def self._improve(moves)
    # Phase 1: sort moves to be optimizable
    opposites = [%w[L R], %w[D U], %w[B F]]

    opposites.each do |side1, side2|
      changed = false
      (0..moves.length-2).each do |i|
        if moves[i][0] == side2 && moves[i+1][0] == side1 # un-normalized order
          moves[i], moves[i+1] = moves[i+1], moves[i]     # swaping the moves gives better order
          changed = true
        end
      end
      return true if changed
    end

    # Phase 2: Moves are correctly ordered. It's time to replace L L with L2, etc
    for i in 0..moves.length-2
      m1, m2 = moves[i], moves[i + 1]

      if m1[0] == m2[0]  # Both moves are on the same side, so merge them!
        moves.delete_at(i+1)  # Delete second move

        side = m1[0]
        case (Move.turns(m1) + Move.turns(m2)) % 4
        when 0
          moves.delete_at(i)  # The moves cancelled out, so also delete the first move
        when 1
          moves[i] = side
        when 2
          moves[i] = side + "2"
        when 3
          moves[i] = side + "'"
        end
        return true  # `moves` was changed. Call this again!
      end
    end

    return false  # Nothing changed. We're done.
  end

  def to_classic(xyz_alg)  # TODO This seems duplicative now, no?
    raw_real_moves = DuAlg.new(xyz_alg).as_list.filter_map do |move|
      moved_real_side = track(move)
      moved_real_side + move[1].to_s if moved_real_side
    end

    SideTracker.normalize(raw_real_moves)
  end

  def side_at(side)
    @side_at[side]
  end
end

module MoveSet
  BRDFLU = :brdflu
  XYZ    = :xyz
  ALL    = :all
end


class NotationDoctor
  def self.to_classic_notation(alg)  # "classic" == BRDFLU only notation
    xyz_alg = self._to_classic_plus_xyz(alg)
    return SideTracker.new.to_classic(xyz_alg)
  end

  def self._to_classic_plus_xyz(alg)
    # All MES and brdflu moves can be mechanically replaced by BRDFLU and xyz moves. We do this here:

    xyz_moves = DuAlg.new(alg).as_list.map! { |move| ADVANCED_MOVE_DEFS[move] || move }.flatten
    DuAlg.new(xyz_moves, MoveSet::XYZ)
  end

end

ADVANCED_MOVE_DEFS = { # Translate MES and brdflu notation to only BRDFLU+xyz moves
                       "M"  => %w(L' R x'), "M2" => %w(L2 R2 x2), "M'" => %w(L R' x),
                       "E"  => %w(D' U y'), "E2" => %w(D2 U2 y2), "E'" => %w(D U' y),
                       "S"  => %w(F' B z'), "S2" => %w(F2 B2 z2), "S'" => %w(F B' z),
                       "b"  => %w(F z'), "b2" => %w(F2 z2), "b'" => %w(F' z'),
                       "r"  => %w(L x), "r2" => %w(L2 x2), "r'" => %w(L' x'),
                       "d"  => %w(U y'), "d2" => %w(U2 y2), "d'" => %w(U' y'),
                       "f"  => %w(B z), "f2" => %w(B2 z2), "f'" => %w(B' z'),
                       "l"  => %w(R x'), "l2" => %w(R2 x2), "l'" => %w(R' x),
                       "u"  => %w(D y), "u2" => %w(D2 y2), "u'" => %w(D' y'),
}.freeze
