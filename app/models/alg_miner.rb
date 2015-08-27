class AlgMiner
  ALL_MOVES = [[:F,1],[:F,2],[:F,3],[:B,1],[:B,2],[:B,3],[:R,1],[:R,2],[:R,3],[:L,1],[:L,2],[:L,3],[:U,1],[:U,2],[:U,3],[:D,1],[:D,2],[:D,3]].freeze

  TABLE_DEPTH = 4
  SEARCH_DEPTH = 5

  def self.go!
    puts "Table depth: #{TABLE_DEPTH}, Search depth: #{SEARCH_DEPTH}. Should find all #{TABLE_DEPTH + SEARCH_DEPTH} move algs"
    t1 = Time.now

    end_states = EndStateMiner.new(TABLE_DEPTH).run()

    t2 = Time.now

    algs_by_length = AlgDigger.new(SEARCH_DEPTH, end_states).run()

    puts "Finding end states: #{t2 - t1}. Searching: #{Time.now - t2}. Total time #{Time.now - t1}"
    algs_by_length.keys.sort.each { |k| puts "#{k} moves: #{algs_by_length[k].count} real algs" }

    write_algs_to_file(algs_by_length)
  end

  def self.write_algs_to_file(algs_by_length)
    file_name = Time.now.strftime("algs_%b%d_%H:%M_#{TABLE_DEPTH}-#{SEARCH_DEPTH}.txt")
    open(file_name, 'w') { |f|
      f.puts "Table depth: #{TABLE_DEPTH}, Search depth: #{SEARCH_DEPTH}."
      algs_by_length.keys.sort.each { |k| f.puts "#{k} moves: #{algs_by_length[k].count} algs" }

      algs_by_length.keys.sort.each do |k|
        f.puts "\n# #{k}"
        algs_by_length[k].to_a.sort.each { |a| f.puts a }
      end
    }
  end

  def self.next_moves(last_move)
    forbidden_sides = {B: [:B], F: [:B, :F], L: [:L], R: [:L, :R], D: [:D], U: [:D, :U]}
    all_moves_but(forbidden_sides[last_move.first])
  end

  def self.all_moves_but(not_these)
    ALL_MOVES.reject { |move| not_these.include? move.first }
  end

  def self.as_alg(moves)
    x = [nil, '', '2', "'"]
    moves.map{ |move| "#{move.first}#{x[move.last]}" }.join(' ')
  end
end

class EndStateMiner

  def initialize(stop_depth)
    @stop_depth = stop_depth
  end

  def run
    @solved_states = Hash.new { |hash, state| hash[state] = [] }
    @cube = Cube.new

    mine_end_states(AlgMiner.all_moves_but([:U]), [])

    puts "Got #{@solved_states.values.map(&:length).sum} solutions for #{@solved_states.count} end positions."
    @solved_states
  end

  def mine_end_states(allowed_moves, moves_so_far)
    allowed_moves.each do |move|
      @cube.unmove(move.first, move.last)

      current_moves = [move] + moves_so_far
      if moves_so_far.count + 1 == @stop_depth
        @solved_states[@cube.f2l_state_string] << AlgMiner.as_alg(current_moves)
      else
        special_case = moves_so_far.empty? && (move.first == :D)
        next_moves = (special_case ? AlgMiner.all_moves_but([:D, :U]) : AlgMiner.next_moves(move))
        mine_end_states(next_moves, current_moves)
      end

      @cube.move(move.first, move.last)
    end
  end
end

class AlgDigger

  def initialize(search_depth, end_states)
    @search_depth = search_depth
    @end_states = end_states
  end

  def run()
    @cube = Cube.new
    @candidate_algs = []

    dig_deeper([[:F, 1], [:F, 2], [:F, 3]], [])

    clean_up
  end

  def dig_deeper(moves, earlier_moves)
    at_final_depth = (earlier_moves.length == @search_depth - 1)

    moves.each do |move|
      @cube.move(move.first, move.last)

      if @end_states.has_key?(@cube.f2l_state_string)
        @end_states[@cube.f2l_state_string].each do |finish|
          unless finish.start_with? move.first.to_s # Ignore the inverse of the moves we just made
            puts "#{@candidate_algs.count} found." if @candidate_algs.count % 200 == 0
            @candidate_algs << "#{AlgMiner.as_alg(earlier_moves + [move])} #{finish}"
          end
        end
      end
      dig_deeper(AlgMiner.next_moves(move), earlier_moves + [move]) unless at_final_depth

      @cube.unmove(move.first, move.last)
    end
  end

  def clean_up
    algs_by_length = Hash.new { |hash, key| hash[key] = Set.new }
    bad_count = 0
    @candidate_algs.each do |alg|
      if solvedish(alg) || bad_merge(alg)
        bad_count += 1
      else
        algs_by_length[alg.split.size] << BaseAlg.normalize(alg)
      end
    end
    puts "#{@candidate_algs.count} candidates. #{@candidate_algs.count - bad_count} good. #{bad_count} bad."
    algs_by_length
  end

  def solvedish(alg)
    unless @solvedish_states
      cube = Cube.new
      @solvedish_states = 4.times.map { |i| cube.move(:U, 1); cube.state_string }
    end

    @solvedish_states.include?(Cube.new(alg).state_string)
  end

  def bad_merge(alg)
    sides = alg.gsub(/[ '2]/,'')
    %w(FBF BFB RLR LRL UDU DUD).detect { |bad| sides.include?(bad) }
  end
end