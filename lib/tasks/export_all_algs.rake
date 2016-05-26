task export_all_algs: :environment do
  file_name = Time.now.strftime("all_algs_upto_15_%b%d_%H:%M.txt")
  open(file_name, 'w') do |f|
    f.puts "All unique LL algs up to 15 moves, written with a starting B move. Ordered by length and alphabetically by standard notation. By Lars Petrus 2015."

    RawAlg.order(:id).find_each do |alg|
      f.puts [alg.id, alg.name, alg.variant(:B)].join(',')
      puts alg.id if alg.id % 50_000 == 1
    end
  end

end
