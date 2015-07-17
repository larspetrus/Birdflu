class BigThought

  def self.populate_db()
    if Position.count == 0
      ActiveRecord::Base.transaction { Position.generate_all }
    end

    unless ComboAlg.exists?(base_alg1: nil, base_alg2: nil)
      ComboAlg.make_single(OpenStruct.new(name: "Nothing", moves: '', id: nil))
    end

    puts "Starting BigThought.populate_db(): #{BaseAlg.count} base algs"
    start_time = Time.new

    all_root_algs.each do |ad|
      unless BaseAlg.exists?(name: ad.name)
        puts "Adding #{ad.name} Base"
        create_alg_bases(ad.name, ad.moves, ad.type != :singleton)
        create_alg_bases("Anti#{ad.name}", reverse(ad.moves), true) if ad.type == :reverse
      end
    end

    puts "After BigThought.populate_db(): #{BaseAlg.count} base algs. Took #{Time.new - start_time}"
  end

  def self.create_alg_bases(name, moves, mirror)
    a1 = BaseAlg.make(name, moves)

    if mirror
      a2 = self.create_alg_bases(name + "M", mirror(moves), false)
    end
    a2 ? [a1] + a2 : [a1] # awkward but testable
  end

  def self.combine(new_base_alg)
    already_combined = ComboAlg.group(:base_alg1_id).count

    ActiveRecord::Base.transaction do
      BaseAlg.all.select { |alg| already_combined[alg.id] }.each do |old|
        ComboAlg.make_4(old, new_base_alg)
        ComboAlg.make_4(new_base_alg, old)
      end
      ComboAlg.make_4(new_base_alg, new_base_alg)
      ComboAlg.make_single(new_base_alg)
    end
  end

  def self.alg_label(moves)
    result = ""
    moves.split(' ').each do |move|
      result += move
      break unless result.ends_with? '2'
    end
    result
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

  def self.root_alg(name, moves, type = :reverse)
    OpenStruct.new(name: name, moves: moves, type: type)
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
        root_alg("H434",  "R U2 R' B' U R U R' U' B"),
        root_alg("H442b", "L' U2 R L U' L' U R' U2 L"),
        root_alg("H442c", "L' U2 R U' R' U2 R L U' R'"),
        root_alg("H442d", "B' R' U' R B2 L' B' L2 U' L'"),
        root_alg("H464",  "R B2 R2 L U L' U' R2 B2 R'", :singleton),
        root_alg("H519",  "B U2 B2 U' R' U R B2 U' B'"),
        root_alg("H569",  "R B' U' B2 U' B2 U2 B U' R'"),
        root_alg("H604",  "B' R U2 R' B R B' U2 B R'", :mirror_only),
        root_alg("H610a", "R2 D' F2 D R2 B2 D L2 D' B2", :singleton),
        root_alg("H610b", "B2 D' R2 U R2 B2 D L2 U' L2", :singleton),
        root_alg("H615",  "B' R B' D2 F L' F' D2 B2 R'", :singleton),
        root_alg("H644",  "L' B L B' U' B' R' U R B"),
        root_alg("H655",  "L2 D' B D' R2 B' D2 L2 U F'", :mirror_only),
        root_alg("H769",  "R' L' U2 R U R' U2 L U' R"),
        root_alg("H775",  "L' U R' U' R L U2 R' U' R"),
        root_alg("H832",  "B U L U' B' R B L' B' R'"),
        root_alg("H833",  "B' R B U B' U' R2 U R B"),
        root_alg("H846",  "R' B U L U' B' R B L' B'"),
        root_alg("H894",  "B' R' B L' B' R2 B' R' B2 L"),
        root_alg("H904",  "R B2 D B' U B D' B2 U' R'"),
        root_alg("H931",  "L' U R B2 U B2 U' B2 R' L"),
        root_alg("H932",  "B U B' U' L' B' R B R' L"),
        root_alg("H933",  "R D L' B L D' R' B U' B'"),
        root_alg("H942a", "R U2 L B L' U2 L B' R' L'"),
        root_alg("H942b", "B R' U2 R B2 L' B2 L U2 B'"),
        root_alg("H942c", "B R' U2 L U2 L' U2 R U2 B'"),
        root_alg("H942d", "B L' B2 L B2 R' U2 R U2 B'"),
        root_alg("H942e", "L U2 L2 B2 R B' L B2 R' B"),
        root_alg("H942f", "R' U2 R2 B2 L' B' L B2 R' B"),
        root_alg("H971",  "R U B U2  B' U B U B' R'"),
        root_alg("H976",  "R L' U' B' U B U R' U' L"),
        root_alg("H1004", "R U B U' L B' R' B L' B'"),
        root_alg("H1076", "B' R B U B' R' B R U' R'"),
        root_alg("H1112", "B L2 B2 R B' R' B2 L' U2 L'"),
        root_alg("H1113", "R U' L' U R' U2 B' U B L"),
        root_alg("H1125a","L U2 L' U2 R' U L U' R L'"),
        root_alg("H1125b","L2 B2 R B R' B L2 F U2 F'"),
        root_alg("H1134", "R L' B' R' B L U2 B U2 B'"),
        root_alg("H1153a","B' U' R' U2 R U R' U' R B"),
        root_alg("H1153b","B' R' U' R2 U R' B R U' R'"),
        root_alg("H1206", "B L' B L B2 U2 R B' R' B"),
        root_alg("Hwhat?","B' U' R B' R' B2 U' B' U2 B", :singleton),

        root_alg("Buffy", "B' U2 B U2 F U' B' U B F'"), # TODO Jag är H1125aM


        # 11 moves (162 total)
        # root_alg("Benny", "B' U2 B2 U2 B2 U' B2 U' B2 U B"),
        # root_alg("Rune",  "L' U' L U' L U L2 U L2 U2 L'", :mirror_only),
    ]
  end
end