class AlgImport

  WORKING_DIR = "/Volumes/Terry/Birdflu"

  def self.tr_file_name(alg_length)
    "#{WORKING_DIR}/firsttwo-#{alg_length}.mov"
  end

  def self.unsorted_file_name(alg_length)
    "#{WORKING_DIR}/all_algs_#{alg_length}.unsorted"
  end

  def self.sorted_file_name(alg_length)
    "#{WORKING_DIR}/all_algs_#{alg_length}.sorted"
  end

  # Translate from Tom's files to the sorted import format we need
  def self.build_alg_import_files
    (6..20).each do |length|
      d_algs_d = []

      if File.exist?(tr_file_name(length)) && !File.exist?(sorted_file_name(length))
        open(tr_file_name(length)) do |tr_file|
          tr_file.each_line do |tr_line|
            alg_d = Algs.from_tr(tr_line.chomp)
            d_algs_d << alg_d # TODO: write directly to unsorted_file here, to save memory

            if alg_d.end_with?("D", "D2", "D'")
              d_algs_d << alg_d.split(' ').rotate(-1).join(' ')
            end
          end
        end

        open(unsorted_file_name(length), "w") do |unsorted_file|
          d_algs_d.each do |alg|
            alg_m = Algs.mirror(alg)
            new_algs = [alg, alg_m, Algs.reverse(alg), Algs.reverse(alg_m)].map{|a| Algs.official_variant(a)}
            new_algs.each do |alg|
              unsorted_file.write(alg + "\n")
            end
          end
        end

        # User has to execute these manually
        puts "sort #{unsorted_file_name(length)} | uniq > sorted_file_name(length)"
      end
    end
  end

  def self.import_algs_to_db(alg_length)
    puts("Importing algs length #{alg_length}")
    t1 = Time.now
    id_count = 0
    ActiveRecord::Base.transaction do
      open("#{WORKING_DIR}/all_algs_#{alg_length}.sorted") do |import_file|
        import_file.each_line do |line|
          id_count += 1

          RawAlg.make(line.chomp, alg_length)

          if id_count % 50_000 == 0
            puts "Alg  #{id_count}: Alg #{line.chomp}, length: #{alg_length} --- #{'%.2f' % (Time.now - t1)}"
          end
        end
      end
    end
  end

end