# frozen_string_literal: true

# Functions for manipulating alg/moves strings

module Algs

  # formatting tolerant alg parser
  def self.parse(alg)
    alg.scan(/[BRDFLU][2\']?/)
  end

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

  # 'rotate' the alg around U. turns = 1 changes F to L, L to B, etc.
  def self.shift(alg, turns = 1)
    rotated = (turns % 4 == 0) ? alg.to_s : alg.to_s.chars.map { |char| (place = 'RFLB'.index(char)) ? 'RFLB'[(place + turns) % 4] : char }.join
    normalize(rotated)
  end

  # Variant producing the standard LL code, which displays right in the UI
  def self.display_variant(alg)
    Algs.shift(alg, self.display_offset(alg))
  end

  def self.display_offset(alg)
    -Cube.new(alg.to_s).standard_ll_code_offset % 4
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

  def self.pack(human_alg)
    human_alg.split(' ').map { |m| Move[m].pack_code }.join
  end

  def self.unpack(packed_alg)
    packed_alg.to_s.chars.map{ |cc| Move[cc].name }.join(' ')
  end

  def self.from_tr(tr_alg) #Tom Rokicki's format
    turn_codes = {'+' => 1, '1' => 2, '-' => 3 }
    move_count = tr_alg.length/2
    moves = (0...move_count).map {|i| Move.name_from(tr_alg[2*i], turn_codes[tr_alg[2*i+1]]) }
    moves.join(' ')
  end

  def self.specialness(alg)
    used_sides = Algs.official_variant(alg).gsub(/[ '2]/,'').chars.uniq.sort.join # official_variant always includes B
    
    case used_sides
      when 'BU'                then 'FU'
      when 'BFU'               then 'FUB'
      when 'BFR', 'BFL', 'BLR' then 'LFR'
      when 'BDU'               then 'UFD'
      when 'BDF'               then 'FDB'
      when 'BLU', 'BRU'        then 'RFU'
      when 'BDL', 'BDR'        then 'RFD'
      else
        raise "Missed Gen code '#{used_sides}' for alg #{alg}" if used_sides.length == 3
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

  # The variant name is the first non D side moved
  def self.variant_name(alg) # Be careful with slices and normalization! "B F ..." vs "F B ..."
    alg.gsub(/[ '2DU]/, '').first
  end

  # The alphabetically first normalized variant. So first non D move is always on B.
  def self.official_variant(alg)
    (0..3).map {|i| Algs.shift(alg, i) }.sort.first
  end

  def self.merge_moves(alg1, alg2)
    start, finish = Algs.normalize(alg1).split(' '), Algs.anti_normalize(alg2).split(' ')
    cancels1, remains, cancels2 = [], [], []

    begin
      if Move.same_side(start.last, finish.first)
        merged_move = Move.merge(start.last, finish.first)
        remains << merged_move if merged_move

        cancels1.insert(0, start.pop)
        cancels2 << finish.shift
      end

      # For cases like "R L + R", flip to "L R + R", and run through again.
      if Move.opposite_sides(start.last, finish.first)
        if Move.opposite_sides(start[-1], start[-2])
          start[-1], start[-2] = start[-2], start[-1]
        elsif Move.opposite_sides(finish[0], finish[1])
          finish[0], finish[1] = finish[1], finish[0]
        end
      end
    end while Move.same_side(start.last, finish.first) && (remains.empty? || Move.opposite_sides(start.last, remains[0]))

    {
        start:   Algs.normalize(start.join(' ')),
        cancel1: Algs.normalize(cancels1.join(' ')),
        merged:  Algs.normalize(remains.join(' ')),
        cancel2: Algs.normalize(cancels2.join(' ')),
        end:     Algs.normalize(finish.join(' ')),
        moves:   Algs.normalize((start + remains + finish).join(' '))
    }
  end

  def self.redundant(alg)
    return true if alg.gsub(/[ '2]/, '').match(/(.)\1+/) # match 2 same chars
    return true if alg.gsub(/[ '2]/, '').gsub('R','L').gsub('U','D').gsub('F','B').match(/(.)\1\1+/) # match 3 same chars
    return false
  end

end
