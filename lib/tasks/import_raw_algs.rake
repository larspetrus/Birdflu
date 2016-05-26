task import_raw_algs: :environment do


  RawAlg.make("", 0) # Debatable entry, but I want it in the DB
  t1 = Time.now
  alg_count = 0
  length = nil
  id_count = nil
  seen_algs = Set.new

  open("lib/tasks/all_ll_algs_15_moves.txt") do |alg_file|
    alg_file.each_line do |line|
      if line.start_with? '#'
        length = line[2..-1].to_i
        id_count = 0
        puts "New length: #{length}"
      end

      if line.start_with?('B') || line.start_with?('D')
        id_count += 1

        b_alg = line.chomp

        rotated_dupe = Algs.rotate_by_U(b_alg, 2)
        unless seen_algs.include? rotated_dupe
          RawAlg.make(b_alg, length)
          seen_algs << b_alg
        end

        alg_count += 1
        if alg_count % 50_000 == 0
          puts "Alg  #{alg_count}: Alg #{line.chomp}, length: #{length} --- #{'%.2f' % (Time.now - t1)}"
        end
      end
    end
  end

  # Optimal solutions for the only positions that need 16 moves
  RawAlg.make("B L2 F' L' F U2 F' L F L2 U' B' U R' U2 R", 'X1', 16)
  RawAlg.make("B' R2 F R F' U2 F R' F' R2 U B U' L U2 L'", 'X2', 16)

  puts "Done. #{alg_count} algs total. Took #{'%.2f' % (Time.now - t1)}"

  RawAlg.populate_mirror_id

  BigThought.initialize_positions
end