class BigThought

  def self.populate_db(regenerate)
    if regenerate
      Position.delete_all
      LlAlg.delete_all
    end

    if Position.count == 0
      ActiveRecord::Base.transaction { Position.generate_all }
    end

    if LlAlg.count > 0
      puts "DB already populated. Skipping generation. #{Position.count} positions, #{LlAlg.count} algs"
      return
    end
    puts "Starting BigThought.populate_db(): #{Position.count} positions, #{LlAlg.count} algs"
    start_time = Time.new

    ActiveRecord::Base.transaction do
      all_root_algs.each do |ad|
        alg_variants(ad.name, ad.moves, ad.type != :singleton)
        alg_variants("Anti#{ad.name}", reverse(ad.moves), true) if ad.type == :reverse
      end

      all_bases = LlAlg.where(kind: ['solve', 'generator'])
      LlAlg.where(kind: 'solve').each do |alg1|
        LlAlg.create_combo(alg1)
        all_bases.each { |alg2| LlAlg.create_combo(alg1, alg2) }
      end

      Position.all.each { |p| p.update(alg_count: p.ll_algs.count, best_alg_id: p.ll_algs[0].try(:id)) }
    end

    puts "After BigThought.populate_db(): #{Position.count} positions, #{LlAlg.count} algs. Took #{Time.new - start_time}"
  end

  def self.all_root_algs
    [
        # 6 moves (1 total)
        root_alg("H435",  "F R U R' U' F'"),
        # 7 moves (3 total)
        root_alg("Sune",  "F U F' U F U2 F'"),
        root_alg("H181",  "L' B' R B' R' B2 L"),
        root_alg("Niklas","L U' R' U L' U' R", :mirror_only),
        # 8 moves (7 total)
        root_alg("H17",   "B U B2 R B R2 U R", :mirror_only),
        root_alg("H304a", "B' R' U R B L U' L'"),
        root_alg("H347a", "B' U' B' R B R' U B"),
        root_alg("Clix",  "L' B' R B L B' R' B"), #H518a
        root_alg("H518b", "B L B' R B L' B' R'"),
        root_alg("H918",  "R B2 L' B2 R' B L B'"),
        root_alg("H1161", "R' U' R U R B' R' B"),
        # 9 moves (19 total)
        root_alg("Arne",  "R2 F2 B2 L2 D L2 B2 F2 R2", :singleton), #H31a/b
        root_alg("Allan", "F2 U R' L F2 R L' U F2", :mirror_only), #H113
        root_alg("H117a", "B' R' B2 D2 F2 L' F2 D2 B'", :mirror_only),
        root_alg("H117b", "B' L' D2 F2 U2 R' F2 D2 B'", :mirror_only),
        root_alg("Bruno", "L U2 L2 U' L2 U' L2 U2 L", :mirror_only), #H183
        root_alg("H187",  "B' R B2 L' B2 R' B2 L B'", :mirror_only),
        root_alg("H304b", "B' R' U R U2 R' U' R B"),
        root_alg("H304c", "B U B' R' U2 R B U' B'"),
        root_alg("H347b", "B' R' U' R B U' B' U2 B"),
        root_alg("H347c", "L' B2 R B R' U' B U L"),
        root_alg("H442",  "L' B2 R D' R D R2 B2 L"),
        root_alg("H468",  "B U2 B' R B' R' B2 U2 B'", :singleton),
        root_alg("H484",  "B2 L2 B R B' L2 B R' B", :mirror_only),
        root_alg("H534",  "R U2 R D R' U2 R D' R2"),
        root_alg("H568",  "B' R2 B' L2 B R2 B' L2 B2"),
        root_alg("H787",  "R U2 R D L' B2 L D' R2"),
        root_alg("H806a", "B' U' R U B U' B' R' B"),
        root_alg("H806b", "R L' U B U' B' R' U' L"),
        root_alg("H886",  "L2 B2 R B R' B2 L B' L"),
        # 10 moves (53 total)
        root_alg("H32",   "R' U2 R U B L U2 L' U' B'", :singleton),
        root_alg("H48",   "R U B U' L U' L' U B' R'"),
        root_alg("H50",   "R B U B' R B' R' B U' R'", :mirror_only),
        root_alg("H116a", "R B L' B' R' L U L U' L'"),
        root_alg("H116b", "B L' B' R' L U L U' R L'"),
        root_alg("H167",  "L' U R' U' R2 D B2 D' R' L"),
        root_alg("H179",  "R B R' L U L' U' R B' R'"),
        root_alg("H208",  "R B U B' U' B U B' U' R'"),
        root_alg("H275a", "R B L' B L B' U B' U' R'", :singleton),
        root_alg("H275b", "R B U B' U R' U' R U' R'", :singleton),
        root_alg("H341",  "L2 B2 R B' D' B D R' B2 L2"),
        root_alg("H370",  "R L' B L' B' D' B D R' L2"),
        root_alg("H371",  "B' R B' R' B' L' B' L2 U2 L'", :mirror_only),
        root_alg("H405",  "B2 R2 B' L U L' U' B R2 B2"),
        root_alg("Buffy", "B' U2 B U2 F U' B' U B F'"),
        # 11 moves (162 total)
        root_alg("Benny", "B' U2 B2 U2 B2 U' B2 U' B2 U B"),
        root_alg("Rune",  "L' U' L U' L U L2 U L2 U2 L'", :mirror_only),
    ]
  end
  
  def self.root_alg(name, moves, type = :reverse)
    OpenStruct.new(name: name, moves: moves, type: type)
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