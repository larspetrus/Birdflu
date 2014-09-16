class BigThought

  def self.populate_db(force_db)
    if force_db
      Position.delete_all
      LlAlg.delete_all
    end

    if Position.count > 0
      puts "DB already populated. Skipping generation. #{Position.count} positions, #{LlAlg.count} algs"
      return
    end
    puts "Starting BigThought.populate_db(): #{Position.count} positions, #{LlAlg.count} algs"

    alg_data = [
        ["Sune",     "F U F' U F U2 F'"],
        ["AntiSune", "F U2 F' U' F U' F'"],
        ["Allan",    "F2 U R' L F2 R L' U F2"],
        ["Bruno",    "L U2 L2 U' L2 U' L2 U2 L"],
        ["Benny",    "B' U2 B2 U2 B2 U' B2 U' B2 U B"],
        ["AntiBenny","B U B2 U' B2 U' B2 U2 B2 U2 B'"],
        ["Arne",     "R2 F2 B2 L2 D L2 B2 F2 R2"],
        ["Rune",     "L' U' L U' L U L2 U L2 U2 L'"],
        ["Bert",     "F2 B2 D R2 F2 B2 L2 F2 B2 D' F2 B2"],

        ["Niklas",   "L U' R' U L' U' R"],
        ["Clix",     "F' L' B L F L' B' L"],
        ["Evelyn",   "R B' R' F R B R' F'"],

        ["Shorty",    "F R U R' U' F'"],
        ["AntiShorty","F U R U' R' F'"],
        ["Middly",    "R U R' U' R' F R F'"],
        ["AntiMiddly","F R' F' R U R U' R'"],
    ]
    alg_data.each { |ad| alg_variants(ad.first, ad.last) }

    all_base_algs = LlAlg.where(kind: ['solve', 'generator'])
    LlAlg.where(kind: 'solve').each do |alg1|
      LlAlg.create_combo(alg1)
      all_base_algs.each { |alg2| LlAlg.create_combo(alg1, alg2) }
    end
    puts "After BigThought.populate_db(): #{Position.count} positions, #{LlAlg.count} algs"
  end

  def self.alg_variants(name, moves)
    mirrored_moves = mirror(moves)
    result = []
    4.times do |i|
      kind = (i == 0) ? 'solve' : 'generator'

      result << LlAlg.create(name: name, moves: moves, kind: kind)
      moves = LlAlg.rotate_by_U(moves)

      result << LlAlg.create(name: name + "M", moves: mirrored_moves, kind: kind)
      mirrored_moves = LlAlg.rotate_by_U(mirrored_moves)
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