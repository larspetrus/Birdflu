class AlgMiner
  ALL_MOVES = [[:F,1],[:F,2],[:F,3],[:B,1],[:B,2],[:B,3],[:R,1],[:R,2],[:R,3],[:L,1],[:L,2],[:L,3],[:U,1],[:U,2],[:U,3],[:D,1],[:D,2],[:D,3]].freeze

  TABLE_DEPTH = 4
  SEARCH_DEPTH = 5

  def self.go!
    puts "Table depth: #{TABLE_DEPTH}, Search depth: #{SEARCH_DEPTH}. Should find all #{TABLE_DEPTH + SEARCH_DEPTH} move algs"
    t1 = Time.now
    @@candidate_algs = []
    @@end_states = find_end_states

    t2 = Time.now
    cube = Cube.new
    dig_for_algs(cube, [[:F, 1], [:F, 2], [:F, 3]], [])
    puts "Found #{@@candidate_algs.count} Algs"
    puts "Finding end states: #{t2 - t1}. Searching: #{Time.now - t2}. Total time #{Time.now - t1}"

    result = Hash.new { |hash, key| hash[key] = [] }
    bad_count = 0
    @@candidate_algs.each do |alg|
      if solvedish(alg) || bad_merge(alg)
        bad_count += 1
      else
        result[alg.split.size] << alg
      end
    end

    puts "#{@@candidate_algs.count} candidates. #{@@candidate_algs.count - bad_count} good. #{bad_count} bad."
    result.keys.sort.each { |k| puts "#{k} moves: #{result[k].count} real algs" }

    file_name = Time.now.strftime("algs_%b%d_%H:%M_#{TABLE_DEPTH}-#{SEARCH_DEPTH}.txt")
    open(file_name, 'w') { |f|
      f.puts "Table depth: #{TABLE_DEPTH}, Search depth: #{SEARCH_DEPTH}."
      result.keys.sort.each do |k|
        f.puts "#{k} moves: #{result[k].count} algs"
      end

      result.keys.sort.each do |k|
        f.puts "\n# #{k}"
        result[k].sort.each { |a| f.puts a }
      end
    }
  end

  def self.find_end_states(stop_depth = TABLE_DEPTH)
    result = Hash.new { |hash, key| hash[key] = [] }
    mine_end_states(result, Cube.new, all_moves_but([:U]), [], stop_depth)
    result
  end

  def self.mine_end_states(result, cube, allowed_moves, moves_so_far, stop_depth)
    allowed_moves.each do |move|
      cube.unmove(move.first, move.last)

      moves = [move] + moves_so_far
      if moves_so_far.count + 1 == stop_depth
        result[cube.f2l_state_string] << as_alg(moves)
      else
        special_case = moves_so_far.empty? && (move.first == :D)
        next_moves = (special_case ? all_moves_but([:D, :U]) : next_moves(move))
        mine_end_states(result, cube, next_moves, moves, stop_depth)
      end

      cube.move(move.first, move.last)
    end
  end

  def self.dig_for_algs(cube, moves, earlier_moves)
    final_depth = (earlier_moves.length == SEARCH_DEPTH - 1)

    moves.each do |move|
      cube.move(move.first, move.last)

      if @@end_states.has_key?(cube.f2l_state_string)
        @@end_states[cube.f2l_state_string].each do |finish|
          unless finish.start_with? move.first.to_s # Ignore the inverse of the moves we just made
            puts "#{@@candidate_algs.count} found." if @@candidate_algs.count % 200 == 0
            @@candidate_algs << "#{as_alg(earlier_moves + [move])} #{finish}"
          end
        end
      end

      unless final_depth
        next_moves = next_moves(move)
        dig_for_algs(cube, next_moves, earlier_moves + [move])
      end

      cube.unmove(move.first, move.last)
    end
  end

  def self.next_moves(last_move)
    forbidden_sides = {B: [:B], F: [:B, :F], L: [:L], R: [:L, :R], D: [:D], U: [:D, :U]}
    all_moves_but(forbidden_sides[last_move.first])
  end

  def self.all_moves_but(not_these)
    ALL_MOVES.reject { |move| not_these.include? move.first }

  end

  def self.as_alg(moves)
    x = ['', '', '2', "'"]
    moves.map{ |move| "#{move.first}#{x[move.last]}" }.join(' ')
  end

  def self.solvedish(alg)
    solvedish_states = [
        "BL BR DB DBL DRB DF DLF DFR DL DR FL FR UL UFL ULB UR URF UBR UF UB",
        "BL BR DB DBL DRB DF DLF DFR DL DR FL FR UF URF UFL UB UBR ULB UR UL",
        "BL BR DB DBL DRB DF DLF DFR DL DR FL FR UR UBR URF UL ULB UFL UB UF",
        "BL BR DB DBL DRB DF DLF DFR DL DR FL FR UB ULB UBR UF UFL URF UL UR",
    ]

    solvedish_states.include?(Cube.new(alg).state_string)
  end

  def self.bad_merge(alg)
    sides = alg.gsub(/[ '2]/,'')
    %w(FBF BFB RLR LRL UDU DUD).detect { |bad| sides.include?(bad) }
  end
end