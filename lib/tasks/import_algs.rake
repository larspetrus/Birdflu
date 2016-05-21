task :import_algs, [:upto_length] => :environment do |t, args|
  upto_length = args[:upto_length].to_i

  if upto_length < 6 || upto_length > 20
    puts "USAGE:\n rake import_algs[X]\nwhere X is in 6..20"
  else
    import_upto(upto_length)
  end

end

def import_upto(upto)
  puts "Importing algs up to length #{upto}"

  import(0)
  6.upto(upto).each { |import_length| import(import_length) }
  PositionStats.generate_all
end

def import(alg_length)
  count = RawAlg.where(length: alg_length).count
  if count > 0
    puts "Algs of length #{alg_length} already populated: #{count} algs"
  else
    puts "\nImporting algs for length #{alg_length}"
    if alg_length == 0
      nil_alg = RawAlg.make("", 'Nothing', 0) # Debatable entry, but I want it in the DB
      nil_alg.update(mirror_id: nil_alg.id)
    else
      AlgImport.import_algs_to_db(alg_length, alg_length <= 14)
    end
  end
end

