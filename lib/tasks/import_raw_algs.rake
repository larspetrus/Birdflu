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

      if line.start_with? 'F'
        id_count += 1
        code = "#{(64+length).chr}#{id_count}"

        RawAlg.create(f_alg: line.chomp, alg_id: code, length: length)

        alg_count += 1
        if alg_count % 10_000 == 0
          puts "Alg  #{alg_count}: Alg #{line.chomp}, length: #{length}, code: #{code}"
        end
      end
    end
    puts "Done. #{alg_count} algs total"
  end
end