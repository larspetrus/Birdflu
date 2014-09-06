class BigThought

  def self.populate_db()
    all_variations_algs = []

    all_variations_algs.concat alg_variants("Sune",  "F U F' U F U2 F'")
    all_variations_algs.concat alg_variants("Allan", "F2 U R' L F2 R L' U F2")
    all_variations_algs.concat alg_variants("Bruno", "L U2 L2 U' L2 U' L2 U2 L")

    primary_algs = all_variations_algs.select { |alg| alg.primary }

    @positions = {}

    primary_algs.each do |alg1|
      add(alg1)
      all_variations_algs.each { |alg2| add(LlAlg.combo(alg1, alg2)) }
    end

    puts "-"*88
    puts @positions.size
    @positions.each do |key, value|
      puts "#{key} - #{value.map(&:nl)}"
    end
  end

  def self.add(alg)
    ll_code = alg.solves_ll_code
    @positions[ll_code] ||= []
    @positions[ll_code] << alg
    @positions[ll_code].sort! { |x,y| x.length <=> y.length }
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