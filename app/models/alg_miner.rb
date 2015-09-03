class AlgMiner
  # Currently set to store data in memory.
  # To use a file instead uncomment the %%% lines and comment the @@@ lines. (Not tested. I might have missed something)

  ALL_MOVES = [[:F,1],[:F,2],[:F,3],[:B,1],[:B,2],[:B,3],[:R,1],[:R,2],[:R,3],[:L,1],[:L,2],[:L,3],[:U,1],[:U,2],[:U,3],[:D,1],[:D,2],[:D,3]].freeze

  LOGGING = true

  def initialize(table_depth)
    @table_depth = table_depth
    t1 = Time.now
    AlgMiner.log "Finding End States, #{@table_depth} levels deep"
    @end_states = GoalFinder.new(@table_depth)
    # @end_states.load_from_file() # %%%
    @end_states.run() # @@@
    AlgMiner.log "End states done: #{Time.now - t1}."
  end

  def search(search_depth)
    AlgMiner.log "Table depth: #{@table_depth}, Search depth: #{search_depth}. Should find all #{@table_depth + search_depth} move algs"
    t1 = Time.now
    algs_by_length = AlgDigger.new(search_depth, @end_states).run()

    AlgMiner.log "Searching done: #{Time.now - t1}"
    algs_by_length.keys.sort.each { |k| AlgMiner.log "#{k} moves: #{algs_by_length[k].count} real algs" }
    AlgMiner.log "Algs sorted: #{Time.now - t1}"

    write_algs_to_file(algs_by_length, search_depth)
    AlgMiner.log "File written: #{Time.now - t1}"
  end

  def write_algs_to_file(algs_by_length, search_depth)
    file_name = Time.now.strftime("algs_%b%d_%H:%M_#{@table_depth}-#{search_depth}.txt")
    open(file_name, 'w') { |f|
      f.puts "Table depth: #{@table_depth}, Search depth: #{search_depth}."
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

  TURN_CODES = [nil, '', '2', "'"]
  def self.as_alg(moves)
    moves.map{ |move| "#{move.first}#{TURN_CODES[move.last]}" }.join(' ')
  end

  MOVE_ENCODING = {
      F: ['', 'F', 'f', 'E'],
      B: ['', 'B', 'b', 'q'],
      R: ['', 'R', 'r', 'P'],
      L: ['', 'L', 'l', '1'],
      U: ['', 'U', 'u', 'n'],
      D: ['', 'D', 'd', 'p']
  }
  def self.compress_alg(moves)
    moves.map{ |move| MOVE_ENCODING[move.first][move.last] }.join('')
  end

  DECOMPRESS = {
      'F'=>'F', 'f'=>'F2', 'E'=>"F'",
      'B'=>'B', 'b'=>'B2', 'q'=>"B'",
      'R'=>'R', 'r'=>'R2', 'P'=>"R'",
      'L'=>'L', 'l'=>'L2', '1'=>"L'",
      'U'=>'U', 'u'=>'U2', 'n'=>"U'",
      'D'=>'D', 'd'=>'D2', 'p'=>"D'"
  }
  def self.decompress_alg(compressed)
    compressed.chars.map{ |cc| DECOMPRESS[cc] }.join(' ')
  end

  def self.log(string)
    puts string if LOGGING
  end
end

class GoalFinder

  def initialize(stop_depth)
    @stop_depth = stop_depth
  end

  def run
    @start_run = Time.now

    # @data_file = File.open("solution_data.txt", "w") # %%%

    @solved_states = {}
    @cube = Cube.new

    mine_end_states(AlgMiner.all_moves_but([:U]), [])

    # @data_file.close # %%%
    AlgMiner.log "Got #{@solved_states.values.map(&:length).sum} solutions for #{@solved_states.count} end positions."
    self
  end

  def load_from_file
    last_time = @start_run = Time.now
    @solved_states = {}
    line_count = 0
    open("depth_7_goals.big") do |big_file|
      big_file.each_line do |line|
        f2l_state, compressed_moves = line.chomp.split(',')

        if @solved_states[f2l_state]
          @solved_states[f2l_state] += "|#{compressed_moves}"
        else
          @solved_states[f2l_state] = compressed_moves
        end

        if line_count % 500_000 == 0
          now = Time.now
          AlgMiner.log "Time: #{'%.2f' % (now - @start_run)}. Increment: #{'%.2f' % (now - last_time)}.  #{line_count}. #{@solved_states.count} end positions."
          last_time = now
        end
        line_count += 1
      end
    end
  end

  def mine_end_states(allowed_moves, moves_so_far)
    allowed_moves.each do |move|
      @cube.unmove(move.first, move.last)
      if moves_so_far.length <= 1
        AlgMiner.log "Time: #{'%.2f' % (Time.now - @start_run)}. Move: #{(moves_so_far + [move]).map{|m| m.join}}. Got #{@solved_states.count} end positions."
      end

      current_moves = [move] + moves_so_far
      if moves_so_far.count + 1 == @stop_depth
        # @data_file.puts "#{@cube.f2l_state_string},#{AlgMiner.compress_alg(current_moves)}\n" # %%%

        if @solved_states[@cube.f2l_state_string] # @@@
          @solved_states[@cube.f2l_state_string] += "|#{AlgMiner.compress_alg(current_moves)}" # @@@
        else # @@@
          @solved_states[@cube.f2l_state_string] = AlgMiner.compress_alg(current_moves) # @@@
        end # @@@
      else
        dont_end_in_U_D = moves_so_far.empty? && (move.first == :D)
        next_moves = (dont_end_in_U_D ? AlgMiner.all_moves_but([:D, :U]) : AlgMiner.next_moves(move))
        mine_end_states(next_moves, current_moves)
      end

      @cube.move(move.first, move.last)
    end
  end

  def solutions_for(cube)
    return [] unless @solved_states.has_key?(cube.f2l_state_string)

    @solved_states[cube.f2l_state_string].split('|').map{|comprsd| AlgMiner.decompress_alg(comprsd) }
  end

  def finishes # for test
    @solved_states.values.map {|x| AlgMiner.decompress_alg(x)}
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

      @end_states.solutions_for(@cube).each do |finish|
        unless finish.start_with? move.first.to_s # Ignore the inverse of the moves we just made
          AlgMiner.log "#{@candidate_algs.count} found." if @candidate_algs.count % 1000 == 0
          @candidate_algs << "#{AlgMiner.as_alg(earlier_moves + [move])} #{finish}"
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
    AlgMiner.log "#{@candidate_algs.count} candidates. #{@candidate_algs.count - bad_count} good. #{bad_count} bad."
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