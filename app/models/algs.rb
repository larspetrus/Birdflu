# Functions for manipulating alg/moves strings

module Algs

  def self.mirror(alg)
    mirrored = alg.split(' ').map{ |move| MIRROR_MOVES[move] }
    normalize(mirrored.join(' '))
  end

  def self.reverse(alg)
    reversed = []
    alg.split(' ').reverse.each do |move|
      turns_code = {"2" => "2", "'" => ""}[move[1]] || "'"
      reversed << move[0]+turns_code
    end
    normalize(reversed.join(' '))
  end

  def self.rotate_by_U(alg, turns = 1)
    rotated = alg.chars.map { |char| (place = 'RFLB'.index(char)) ? 'RFLB'[(place + turns) % 4] : char }.join
    normalize(rotated)
  end

  def self.normalize(alg)
    _normalize(alg, %w(RL UD FB))
  end

  def self.anti_normalize(alg)
    _normalize(alg, %w(LR DU BF))
  end

  def self._normalize(alg, pair_order)
    # Sort pairs of L & R, D & U, B & F alphabetically
    moves = alg.split(' ')
    (moves.length-1).times do |i|
      if pair_order.include? moves[i][0]+moves[i+1][0]
        moves[i+1], moves[i] = moves[i], moves[i+1]
        alg = moves.join(' ') # questionable speed optimization
      end
    end
    alg
  end

  def self.u_setup(alg)
    cube = Cube.new(alg)
    ('BRFL'.index(cube.piece_at('UB').name[1]) - LL.edge_data(cube.standard_ll_code[1]).distance) % 4
  end

  def self.compress(human_alg)
    human_alg.split(' ').map { |m| Move[m].compressed_code }.join
  end

  def self.expand(compressed_alg)
    compressed_alg.chars.map{ |cc| Move[cc].name }.join(' ')
  end

  def self.sides(alg)
    alg.gsub(/[ '2]/,'').chars.uniq.sort.join
  end

  GENS = {
      "BU" => '2gen',

      "BFU"=> '3genOpp',
      "BFR"=> '3genOpp',
      "BFL"=> '3genOpp',
      "BLR"=> '3genOpp',
      "BDU"=> '3genOpp',
      "BDF"=> '3genOpp',

      "BLU"=> '3genAdj',
      "BRU"=> '3genAdj',
      "BDL"=> '3genAdj',
      "BDR"=> '3genAdj',
  }
  def self.specialness(b_alg)
    GENS[Algs.sides(b_alg)]
  end

  def self.speed_score(alg)
    side_base = {'D' => 1.2, 'U' => 0.8}

    as_moves = alg.split(' ')
    scores = as_moves.map do |move|
      factor = (move[1] == '2' ? 1.5 : 1.0)
      (side_base[move[0]] || 1.0) * factor
    end

    as_moves.size.times do |i|
      if i >= 2 && Move.same_side(as_moves[i-2], as_moves[i])
        scores[i] *= 0.6
      end
      if i >= 1 && Move.opposite_sides(as_moves[i-1], as_moves[i])
        scores[i] *= 0.8
      end
    end
    scores.sum.round(2)
  end

  MIRROR_MOVES = begin
    {}.tap do |result|
      %w(R L U D F B).each do |side|
        opposite_side = {'R'=>'L', 'L'=>'R'}[side] || side
        1.upto(3) { |turns| result[Move.name_from(side, turns)] = Move.name_from(opposite_side, 4-turns) }
      end
    end
  end

end
