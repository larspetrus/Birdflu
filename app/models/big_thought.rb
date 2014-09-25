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
      all_root_algs.each do |ad|
        alg_variants(ad[0], ad[1], ad[2] != :singleton)
        if ad[2] == :reverse
          alg_variants("Anti#{ad[0]}", reverse(ad[1]), true)
        end
      end

      all_bases = LlAlg.where(kind: ['solve', 'generator'])
      LlAlg.where(kind: 'solve').each do |alg1|
        LlAlg.create_combo(alg1)
        all_bases.each { |alg2| LlAlg.create_combo(alg1, alg2) }
      end

      Position.all.each { |p| p.update(alg_count: p.ll_algs.count, best_alg_id: p.ll_algs[0].id) }
    end

    puts "After BigThought.populate_db(): #{Position.count} positions, #{LlAlg.count} algs. Took #{Time.new - start_time}"
  end

  def self.all_root_algs
    [
        # 6 moves (1 total)
        ["Shorty",    "F R U R' U' F'", :reverse],
        # 7 moves (3 total)
        ["Sune",      "F U F' U F U2 F'", :reverse],
        ["BH181",     "L' B' R B' R' B2 L", :reverse],
        ["Niklas",    "L U' R' U L' U' R", :mirror_only],
        # 8 moves (7 total)
        ["BH1161",    "R' U' R U R B' R' B", :reverse],
        ["BH17",      "B U B2 R B R2 U R", :mirror_only],
        ["BH304a",    "B' R' U R B L U' L'", :reverse],
        ["BH347a",    "B' U' B' R B R' U B", :reverse],
        ["BH918",     "R B2 L' B2 R' B L B'", :reverse],
        ["Clix",      "F' L' B L F L' B' L", :reverse],
        ["BH518b",    "B L B' R B L' B' R'", :reverse],
        # 9 moves (19 total)
        ["Allan",    "F2 U R' L F2 R L' U F2", :mirror_only],
        ["Bruno",    "L U2 L2 U' L2 U' L2 U2 L", :mirror_only], #BH183
        ["Arne",     "R2 F2 B2 L2 D L2 B2 F2 R2", :singleton],
        ["BH117a",   "B' R' B2 D2 F2 L' F2 D2 B'", :mirror_only],
        ["BH117b",   "B' L' D2 F2 U2 R' F2 D2 B'", :mirror_only],
        ["BH187",    "B' R B2 L' B2 R' B2 L B'", :mirror_only],
        ["BH304b",   "B' R' U R U2 R' U' R B", :reverse],
        ["BH304c",   "B U B' R' U2 R B U' B'", :reverse],
        ["BH347b",   "B' R' U' R B U' B' U2 B", :reverse],
        ["BH347c",   "L' B2 R B R' U' B U L", :reverse],
        ["BH442",    "L' B2 R D' R D R2 B2 L", :reverse],
        ["BH468",    "B U2 B' R B' R' B2 U2 B'", :singleton],
        ["BH484",    "B2 L2 B R B' L2 B R' B", :mirror_only],
        ["BH534",    "R U2 R D R' U2 R D' R2", :reverse],
        ["BH568",    "B' R2 B' L2 B R2 B' L2 B2", :reverse],
        ["BH787",    "R U2 R D L' B2 L D' R2", :reverse],
        ["BH806a",   "B' U' R U B U' B' R' B", :reverse],
        ["BH806b",   "R L' U B U' B' R' U' L", :reverse],
        ["BH886",    "L2 B2 R B R' B2 L B' L", :reverse],
        # 10 moves (53 total)
        ["BH50",     "R B U B' R B' R' B U' R'", :mirror_only],
        ["BH116a",   "R B L' B' R' L U L U' L'", :reverse],
        ["BH116b",   "B L' B' R' L U L U' R L'", :reverse],
        ["Buffy",    "B' U2 B U2 F U' B' U B F'", :reverse],
        # 11 moves (162 total)
        ["Benny",    "B' U2 B2 U2 B2 U' B2 U' B2 U B", :reverse],
        ["Rune",     "L' U' L U' L U L2 U L2 U2 L'", :mirror_only],
    ]
  end

  def self.alg_variants(name, moves, mirror)
    mirrored_moves = mirror(moves)
    result = []
    4.times do |i|
      kind = (i == 0) ? 'solve' : 'generator'

      result << LlAlg.create(name: name, moves: moves, kind: kind)
      moves = LlAlg.rotate_by_U(moves)

      if mirror
        result << LlAlg.create(name: name + "M", moves: mirrored_moves, kind: kind)
        mirrored_moves = LlAlg.rotate_by_U(mirrored_moves)
      end
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