class Move

  def self.name_from(side, turns)
    turn_code = [nil, "", "2", "'"]
    "#{side}#{turn_code[turns]}"
  end


  def self.same_side(move1, move2)
    return false if move1.nil? || move2.nil?
    move1[0] == move2[0]
  end

  def self.opposite_sides(move1, move2)
    return false if move1.nil? || move2.nil?
    opposites = {L: :R, R: :L, F: :B, B: :F, U: :D, D: :U}
    opposites[move1[0].to_sym] == move2[0].to_sym
  end

  def self.merge(move1, move2)
    turns = (turns(move1) + turns(move2)) % 4
    turns > 0 ? name_from(move1[0], turns) : nil
  end

  def self.turns(move)
    {"2" => 2, "'" => 3}[move[1]] || 1
  end

end