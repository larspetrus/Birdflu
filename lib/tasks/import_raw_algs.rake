task import_raw_algs: :environment do

  RawAlg.create(b_alg: "", alg_id: 'Nothing', length: 0) # Debatable entry, but I want it in the DB

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
        code = "#{(64+length).chr}#{id_count}"

        b_alg = line.chomp

        rotated_dupe = Algs.rotate_by_U(b_alg, 2)
        unless seen_algs.include? rotated_dupe
          RawAlg.create(b_alg: b_alg, alg_id: code, length: length)
          seen_algs << b_alg
        end

        alg_count += 1
        if alg_count % 50_000 == 0
          puts "Alg  #{alg_count}: Alg #{line.chomp}, length: #{length}, code: #{code} --- #{'%.2f' % (Time.now - t1)}"
        end
      end
    end
  end

  # Optimal solutions for the only positions that needs 16 moves
  RawAlg.create(b_alg: "B L2 F' L' F U2 F' L F L2 U' B' U R' U2 R", alg_id: 'X1', length: 16)
  RawAlg.create(b_alg: "B' R2 F R F' U2 F R' F' R2 U B U' L U2 L'", alg_id: 'X2', length: 16)

  puts "Done. #{alg_count} algs total. Took #{'%.2f' % (Time.now - t1)}"

  RawAlg.populate_mirror_id

  BigThought.initialize_positions
end