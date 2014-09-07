class BigThought

  def self.populate_db()
    if Position.count > 0
      puts "DB already populated. Skipping generation. #{Position.count} positions, #{LlAlg.count} algs"
      return
    end
    puts "Starting BigThought.populate_db(): #{Position.count} positions, #{LlAlg.count} algs"

    alg_data = [
        ["Sune",    "F U F' U F U2 F'"],
        ["AntiSune","F U2 F' U' F U' F'"],
        ["Allan",   "F2 U R' L F2 R L' U F2"],
        ["Bruno",   "L U2 L2 U' L2 U' L2 U2 L"],
    ]
    alg_data.each { |ad| alg_variants(ad.first, ad.last) }

    all_algs = LlAlg.all

    LlAlg.where(primary: true).each do |alg1|
      all_algs.each { |alg2| LlAlg.create_combo(alg1, alg2) }
    end
    puts "After BigThought.populate_db(): #{Position.count} positions, #{LlAlg.count} algs"
  end

  def self.alg_variants(name, moves)
    circle = {'R'=>'F', 'F'=>'L', 'L'=>'B', 'B'=>'R'}

    mirrored_moves = mirror(moves)
    result = []
    4.times do |i|
      result << LlAlg.create(name: name + "-#{alg_label(moves)}", moves: moves, primary: i == 0)
      result << LlAlg.create(name: name + "M-#{alg_label(mirrored_moves)}", moves: mirrored_moves, primary: i == 0)
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