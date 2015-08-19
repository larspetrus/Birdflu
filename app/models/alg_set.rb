class AlgSet

  UNDER_9_IDS = [nil,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39]
  THE71 = [nil,2,3,5,6,7,8,9,10,11,12,13,14,15,19,20,31,35,36,37,38,45,47,50,65,67,68,93,94,101,102,103,105,106,112,127,143,145,148,155,165,166,171,174,175,179,180,182,183,188,189,190,191,192,195,196,198,202,203,206,212,218,227,239,251,254,256,257,259,263,271,272]


  def self.coverage(ids)
    ComboAlg.where(base_alg1_id: ids, base_alg2_id: ids).pluck(:position_id).uniq.count
  end

  def self.also_ids
    [198, 178, 104, 105, 176, 202, 161, 131, 239, 96, 188, 171, 142, 210, 103, 55, 160, 174, 155, 81, 211, 157, 208, 47, 180, 126, 236, 164, 255, 227, 266, 93, 270, 184, 233, 107, 268, 216, 196, 182, 165]
  end

  def self.ids
    UNDER_9_IDS + also_ids
  end

  def self.finder
    hhh = []
    40.upto(277).each do |id|
      unless also_ids.include? id
        hhh << [coverage(ids + [id]), id]
      end
    end
    hhh.sort
  end

  def self.make_minimal_set()
    set = [nil, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
    useless = []
    old_coverage = coverage(set)
    puts "Starting coverage: #{old_coverage}"
    t1 = Time.now
    while old_coverage < 3916 do
      new_coverage = old_coverage
      best_id = nil
      2.upto(277).each do |id|
        unless (set+useless).include? id
          c = coverage(set + [id])
          if c > new_coverage
            new_coverage = c
            best_id = id
          end
          useless << id if c == old_coverage
        end
      end
      puts "Adding id #{best_id}. New coverage #{new_coverage}. #{useless.size} useless. Time #{'%.2f' % (Time.now - t1)}"
      set << best_id
      old_coverage = new_coverage
    end
    puts "[#{set.join(',')}] - #{set.count} algs"

    puts "Trimming"


  end

  def self.trim_minimal_set(ids)
    ids.each do |id|
      puts "Coverage without #{id}: #{coverage(ids - [id])}"
    end
  end

end
