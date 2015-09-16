class AlgMiner
  # Currently set to store data in memory.
  # To use a file instead uncomment the %%% lines and comment the @@@ lines. (Not tested. I might have missed something)

  ALL_MOVES = %w[F F2 F' B B2 B' R R2 R' L L2 L' U U2 U' D D2 D'].map{|x| Move[x]}

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
    open(file_name, 'w') do |f|
      f.puts "Table depth: #{@table_depth}, Search depth: #{search_depth}."
      algs_by_length.keys.sort.each { |k| f.puts "#{k} moves: #{algs_by_length[k].count} algs" }

      algs_by_length.keys.sort.each do |k|
        f.puts "\n# #{k}"
        algs_by_length[k].to_a.sort.each { |a| f.puts a }
      end
    end
  end


  def self.flip_d
    flipped_file = []
    open("FINAL_algs_Sep04_23:48_6-9_D.txt") do |d_file|
      d_file.each_line do |line|
        flipped_file << (line.start_with?('D') ? Algs.mirror(line) : line)
      end
    end
    puts flipped_file

    open("FINAL_flipped_D.txt", 'w') do |f|
      flipped_file.each { |fa|  f.puts fa}
    end
  end


  def self.build_all_ll_algs_file
    length = nil
    algs_by_length = {}
    6.upto(15) { |num| algs_by_length[num] = [] }

    files = ["FINAL_algs_Sep06_23:20_4-3.txt", "FINAL_algs_Sep06_17:45_7-8.txt", "FINAL_algs_Sep04_23:48_6-9_D.txt", "FINAL_flipped_D.txt", "FINAL_algs_Sep05_01:44_6-9_D2.txt"]

    files.each do |file_name|
      puts "Now reading #{file_name}"
      open(file_name) do |file|
        file.each_line do |line|

          if line.start_with? '#'
            length = line[2..-1].to_i
            puts "New length: #{length}"
          end

          if line.start_with?('B') || line.start_with?('D')
            algs_by_length[length] << line
          end

        end
      end
      file_name = Time.now.strftime("all_ll_algs_15_%b%d_%H-%M.txt")
      open(file_name, 'w') do |f|
        f.puts "All LL algs up to 15 moves. Compiled from several runs."
        algs_by_length.keys.sort.each { |k| f.puts "#{k} moves: #{algs_by_length[k].count} algs" }

        algs_by_length.keys.sort.each do |k|
          f.puts "\n# #{k}"
          algs_by_length[k].sort.each { |a| f.puts a }
        end
      end
    end
  end

  def self.next_moves(last_move)
    forbidden_sides = {B: [:B], F: [:B, :F], L: [:L], R: [:L, :R], D: [:D], U: [:D, :U]}
    all_moves_but(forbidden_sides[last_move.side])
  end

  def self.all_moves_but(not_on_these_sides)
    ALL_MOVES.reject { |move| not_on_these_sides.include? move.side }
  end

  def self.as_alg(moves)
    moves.map{ |move| move.name }.join(' ')
  end

  def self.compress_alg(moves)
    moves.map{ |move| move.compressed_code }.join('')
  end

  def self.decompress_alg(compressed)
    compressed.chars.map{ |cc| Move[cc].name }.join(' ')
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
      @cube.unmove(move.side, move.turns)
      if moves_so_far.length <= 1
        AlgMiner.log "Time: #{'%.2f' % (Time.now - @start_run)}. Move: #{(moves_so_far + [move]).map{|m| m.name}}. Got #{@solved_states.count} end positions."
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
        dont_end_in_U_D = moves_so_far.empty? && (move.side == :D)
        next_moves = (dont_end_in_U_D ? AlgMiner.all_moves_but([:D, :U]) : AlgMiner.next_moves(move))
        mine_end_states(next_moves, current_moves)
      end

      @cube.move(move.side, move.turns)
    end
  end

  def solutions_for(cube)
    return [] unless @solved_states.has_key?(cube.f2l_state_string)

    @solved_states[cube.f2l_state_string].split('|').map{|cmprsd| AlgMiner.decompress_alg(cmprsd) }
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

    dig_deeper([Move::B, Move::B2, Move::Bp], [])

    clean_up
  end

  def dig_deeper(moves, earlier_moves, preset_next_moves = nil)
    at_final_depth = (earlier_moves.length == @search_depth - 1)

    moves.each do |move|
      @cube.move(move.side, move.turns)

      @end_states.solutions_for(@cube).each do |finish|
        unless finish.start_with? move.side.to_s # Ignore the inverse of the moves we just made
          AlgMiner.log "#{@candidate_algs.count} found. At #{AlgMiner.as_alg(earlier_moves + [move])}." if @candidate_algs.count % 1000 == 0
          @candidate_algs << "#{AlgMiner.as_alg(earlier_moves + [move])} #{finish}"
        end
      end
      dig_deeper(preset_next_moves || AlgMiner.next_moves(move), earlier_moves + [move]) unless at_final_depth

      @cube.unmove(move.side, move.turns)
    end
  end

  def clean_up
    algs_by_length = Hash.new { |hash, key| hash[key] = Set.new }
    bad_count = 0
    @candidate_algs.each do |alg|
      if solvedish(alg) || bad_merge(alg) || dee_generate(alg)
        bad_count += 1
      else
        algs_by_length[alg.split.size] << Algs.normalize(alg)
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

  def dee_generate(alg)
    (alg.start_with?("D ") && alg.end_with?(" D'")) || (alg.start_with?("D2 ") && alg.end_with?(" D2"))
  end

  def bad_merge(alg)
    sides_only = alg.gsub(/[ '2]/,'')
    %w(FBF BFB RLR LRL UDU DUD).detect { |bad| sides_only.include?(bad) }
  end
end