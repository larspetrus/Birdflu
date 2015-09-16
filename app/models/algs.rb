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
    # Sort pairs of L & R, D & U, B & F alphabetically
    moves = alg.split(' ')
    (moves.length-1).times do |i|
      if %w(RL UD FB).include? moves[i][0]+moves[i+1][0]
        moves[i+1], moves[i] = moves[i], moves[i+1]
        alg = moves.join(' ') # questionable speed optimization
      end
    end
    alg
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
