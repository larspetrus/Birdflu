class BigThought

  def self.populate_db(regenerate)
    if regenerate
      Position.delete_all
      LlAlg.delete_all
    end

    if Position.count > 0
      puts "DB already populated. Skipping generation. #{Position.count} positions, #{LlAlg.count} algs"
      return
    end
    puts "Starting BigThought.populate_db(): #{Position.count} positions, #{LlAlg.count} algs"
    start_time = Time.new

    ActiveRecord::Base.transaction do
      root_algs.each { |ad| alg_variants(ad.first, ad.last) }

      all_bases = LlAlg.where(kind: ['solve', 'generator'])
      LlAlg.where(kind: 'solve').each do |alg1|
        LlAlg.create_combo(alg1)
        all_bases.each { |alg2| LlAlg.create_combo(alg1, alg2) }
      end

      Position.all.each { |p| p.update(alg_count: p.ll_algs.count, best_alg_id: p.ll_algs[0].id) }
    end

    puts "After BigThought.populate_db(): #{Position.count} positions, #{LlAlg.count} algs. Took #{Time.new - start_time}"
  end

  def self.root_algs
    reversibles = [
        ["Sune",     "F U F' U F U2 F'"],
        ["Benny",    "B' U2 B2 U2 B2 U' B2 U' B2 U B"],
        ["BH54",     "R' U2 R' D' L F2 L' D R2"],
        ["BH58",     "R' U2 R' D' R U2 R' D R2"],

        ["Clix",     "F' L' B L F L' B' L"], #BH518 #BLB'RBL'B'R' !?!
        ["Buffy",    "B' U2 B U2 F U' B' U B F'"],

        ["Shorty",    "F R U R' U' F'"],

        ["BH181",     "L' B' R B' R' B2 L"],
        ["BH304",     "B' R' U R B L U' L'"],
        ["BH347",     "B' U' B' R B R' U B"],
        ["BH918",     "R B2 L' B2 R' B L B'"],
        ["BH1161",    "R' U' R U R B' R' B"],
    ]
    others = [
        ["Allan",    "F2 U R' L F2 R L' U F2"],
        ["Bruno",    "L U2 L2 U' L2 U' L2 U2 L"],
        ["Arne",     "R2 F2 B2 L2 D L2 B2 F2 R2"],
        ["Rune",     "L' U' L U' L U L2 U L2 U2 L'"],
        ["Bert",     "F2 B2 D R2 F2 B2 L2 F2 B2 D' F2 B2"],

        ["Niklas",   "L U' R' U L' U' R"],

        ["BH17",      "B U B2 R B R2 U R"],
    ]

    reversed = []
    reversibles.each do |rev|
      reversed << rev
      reversed << ["Anti#{rev[0]}", reverse(rev[1])]
    end

    reversed + others
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

  def self.reverse(moves)
    reversed = []
    moves.split(' ').reverse.each do |move|
      turns = {"2" => "2", "'" => ""}[move[1]] || "'"
      reversed << move[0]+turns
    end
    reversed.join(' ')
  end
end