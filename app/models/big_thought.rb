class BigThought

  def self.alg_variants(name, moves)
    circle = {'R'=>'F', 'F'=>'L', 'L'=>'B', 'B'=>'R'}

    mirrored_moves = mirror(moves)
    result = []
    4.times do |i|
      result << LlAlg.new(name + "-#{alg_label(moves)}", moves, i == 0)
      result << LlAlg.new(name + "M-#{alg_label(mirrored_moves)}", mirrored_moves, i == 0)
      moves = moves.chars.map { |char| circle[char] || char}.join
      mirrored_moves = mirrored_moves.chars.map { |char| circle[char] || char}.join
    end
    result
  end


  def self.alg_label(moves)
    result = ""
    moves.split(' ').each do |move|
      result += move
      return result unless result.ends_with? '2'
    end
  end

  def self.mirror(moves)
    mirrored = []
    moves.split(' ').each do |move|
      side = {'R' => 'L', 'L' => 'R'}[move[0]] || move[0]
      turns = {"2" => "2", "'" => ""}[move[1]] || "'"
      mirrored << side+turns
    end
    mirrored.join(' ')
  end

end