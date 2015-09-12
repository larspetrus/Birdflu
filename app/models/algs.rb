# Functions for manipulating alg/moves strings

module Algs
  def self.mirror(alg)
    mirrored = []
    alg.split(' ').each do |move|
      side = {'R' => 'L', 'L' => 'R'}[move[0]] || move[0]
      turns = {"2" => "2", "'" => ""}[move[1]] || "'"
      mirrored << side+turns
    end
    normalize(mirrored.join(' '))
  end

  def self.reverse(alg)
    reversed = []
    alg.split(' ').reverse.each do |move|
      turns = {"2" => "2", "'" => ""}[move[1]] || "'"
      reversed << move[0]+turns
    end
    normalize(reversed.join(' '))
  end

  def self.rotate_by_U(alg, turns = 1)
    rotated = alg.chars.map { |char| (place = 'RFLB'.index(char)) ? 'RFLB'[(place + turns) % 4] : char }.join
    normalize(rotated)
  end

  def self.normalize(alg)
    # Sort pairs of L & R, D & U, B & F alphabetically
    m = alg.split(' ')
    (m.length-1).times do |i|
      if %w(RL UD FB).include? m[i][0]+m[i+1][0]
        m[i+1], m[i]= m[i], m[i+1]
        alg = m.join(' ') # questionable speed optimization
      end
    end
    alg
  end
end
