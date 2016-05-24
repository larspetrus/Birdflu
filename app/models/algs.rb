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

  # The alg version that produces the standard LL code
  def self.ll_code_variant(alg)
    official_alg = Algs.official_variant(alg)
    rotation = -Cube.new(official_alg).standard_ll_code_offset % 4
    Algs.rotate_by_U(official_alg, rotation)
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

  def self.equivalent_versions(alg)
    normalg = Algs.normalize(alg)
    moves = normalg.split(' ')
    swap_starts = (0..moves.length-2).select{|i| %w(LR DU BF).include? moves[i][0]+moves[i+1][0] }

    result = [normalg]
    swap_starts.each do |swap_start|
      result.dup.each {|alg| result << Algs.swap_moves(alg, swap_start)}
    end
    result
  end

  def self.swap_moves(alg, swap_start)
    moves = alg.split(' ')
    moves[swap_start], moves[swap_start+1] = moves[swap_start+1], moves[swap_start]
    moves.join(' ')
  end

  def self.standard_u_setup(alg)
    cube = Cube.new(alg)
    ('BRFL'.index(cube.piece_at('UB').name[1]) - LL.edge_data(cube.standard_ll_code[1]).distance) % 4
  end

  def self.compress(human_alg)
    human_alg.split(' ').map { |m| Move[m].compressed_code }.join
  end

  def self.expand(compressed_alg)
    compressed_alg.chars.map{ |cc| Move[cc].name }.join(' ')
  end

  def self.from_tr(tr_alg)
    turn_codes = {'+' => 1, '1' => 2, '-' => 3 }
    move_count = tr_alg.length/2
    moves = (0...move_count).map {|i| Move.name_from(tr_alg[2*i], turn_codes[tr_alg[2*i+1]]) }
    moves.join(' ')
  end

  def self.sides(alg)
    alg.gsub(/[ '2]/,'').chars.uniq.sort.join
  end

  def self.specialness(alg)
    b_sides = Algs.sides(Algs.official_variant(alg))
    
    case b_sides
      when 'BU'                then 'FU'
      when 'BFU'               then 'FUB'
      when 'BFR', 'BFL', 'BLR' then 'LFR'
      when 'BDU'               then 'UFD'
      when 'BDF'               then 'FDB'
      when 'BLU', 'BRU'        then 'RFU'
      when 'BDL', 'BDR'        then 'RFD'
      else
        raise "Missed Gen code '#{b_sides}' for alg #{alg}" if b_sides.length == 3
        nil
    end
  end

  def self.speed_score(alg, for_db: false)
    score = Algs.equivalent_versions(alg).map{|a| Algs.single_speed_score(a)}.min
    for_db ? (100*score).round.to_i : score
  end

  def self.single_speed_score(alg)
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

  def self.length(alg)
    alg.split(' ').length
  end

  def self.variant(alg) # TODO works with slices?
    alg.gsub(/[ '2DU]/, '').first
  end

  # The alphabetically first normalized variant. First non D move is always on B.
  def self.official_variant(alg)
    (0..3).map {|i| Algs.rotate_by_U(alg, i) }.sort.first
  end

end
