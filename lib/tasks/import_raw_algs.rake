task import_raw_algs: :environment do
  alg_count = 0
  length = nil
  id_count = nil

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

        RawAlg.create(b_alg: line.chomp, alg_id: code, length: length)

        alg_count += 1
        if alg_count % 10_000 == 0
          puts "Alg  #{alg_count}: Alg #{line.chomp}, length: #{length}, code: #{code}"
        end
      end
    end

    # Optimal solutions for the only position that needs 16 moves
    RawAlg.create(b_alg: "B L2 F' L' F U2 F' L F L2 U' B' U R' U2 R", alg_id: 'X1', length: 16)
    RawAlg.create(b_alg: "B' R2 F R F' U2 F R' F' R2 U B U' L U2 L'", alg_id: 'X2', length: 16)

    puts "Done. #{alg_count} algs total"
  end
end