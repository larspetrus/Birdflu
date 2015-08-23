#Toolbox for making AlgSets

class AlgSetCreator
  def self.coverage(human_algs)
    ids = HumanAlg.set_to_ids(human_algs)
    ComboAlg.where(base_alg1_id: ids, base_alg2_id: ids).pluck(:position_id).uniq.count
  end

  def self.make_minimal_set()
    t1 = Time.now

    all = all_human_algs
    # start_set = %w(h435 A.h435 h806 A.h787 h1004 h971 A.h904 h48 A.h932 h181 A.h806 A.h569 A.h1134 Buffy A.h846 A.h1076 h932 h405 A.h931 h50 A.h1113 h1126 A.Sune h117 A.h48 A.h347 h644 A.h181 A.h208 A.h1004 h569 h655 A.h971 h341 A.h644 A.h894 Czeslaw A.h1126)
    start_set = %w(h435)

    alg_set = all.select {|alg| start_set.include?(alg.name) }
    redundant_algs = []
    coverage = coverage(alg_set)
    puts "Starting coverage: #{coverage}"
    while true do
      best_coverage = coverage
      best_alg = nil

      all.each do |human_alg|
        unless (alg_set+redundant_algs).include? human_alg
          c = coverage(alg_set + [human_alg])
          if c > best_coverage
            best_coverage = c
            best_alg = human_alg
          end
          redundant_algs << human_alg if c == coverage
        end
      end
      break unless best_alg

      puts "Adding #{best_alg}. New coverage #{best_coverage}. #{redundant_algs.size} useless. Time #{'%.2f' % (Time.now - t1)}"
      alg_set << best_alg
      coverage = best_coverage
    end
    puts "[#{alg_set.map(&:name).join(',')}] - #{alg_set.count} algs. . Time #{'%.2f' % (Time.now - t1)}"
    puts "[#{HumanAlg.set_to_ids(alg_set)}]"

    trim_minimal_set(alg_set, coverage)
  end

  def self.trim_minimal_set(alg_set, full_coverage)
    candidates = []
    alg_set.each do |alg|
      coverage_without = coverage(alg_set - [alg])
      if coverage_without == full_coverage
        candidates << alg
        puts "Full coverage without #{alg.name} (#{alg.ids})!"
      end
    end

    candidates.combination(2).each do |pair|
      coverage_without = coverage(alg_set - pair)
      puts "Without pair #{pair.map(&:name)} - #{coverage_without}"
      if coverage_without == full_coverage
        puts "Full coverage without #{pair.map(&:name)} (#{HumanAlg.set_to_ids(pair)})!"
      end
    end
  end


  def self.average_best(human_algs)
    @@current = HumanAlg.set_to_ids(human_algs)
    Position.all.reduce(0.0) { |sum, pos| sum + pos.best_alg_set_length }/3916
  end

  def self.make_fast_set(size = 50)
    t1 = Time.now

    all = all_human_algs
    start_set = NAMES_40 + %w(Niklas Sune A.h918 h17 h304 h1161 A.h1161 h918 h886 A.h518b h519 h518b Bruno h442 h347 h1153 h1153b h787 h534 A.Czeslaw A.h179 A.h519)

    alg_set = all.select {|alg| start_set.include?(alg.name) }

    baseline = average_best(alg_set)
    puts "Baseline: #{baseline}, #{start_set.count} algs"
    all.each do |human_alg|
      unless alg_set.include? human_alg
        ab = average_best(alg_set + [human_alg])
        puts "#{baseline - ab} - #{human_alg.to_s}"
      end
    end
    puts "That took #{'%.2f' % (Time.now - t1)}"
  end

  def self.trim_fast_set()
    t1 = Time.now
    start_set = NAMES_40 +
        %w(Niklas Sune A.h918 h17 h304 h1161 A.h1161 h918 h886 A.h518b h519 h518b Bruno h442 h347 h1153 h1153b h787 h534 A.Czeslaw A.h179 A.h519) -
        %w(h932 A.h644 h341 Buffy A.h971 h48 A.h1004 A.h931 A.Czeslaw 9)

    alg_set = all_human_algs.select {|alg| start_set.include?(alg.name) }

    while alg_set.count >= 50
      slowest = find_slowest_alg(alg_set)
      puts "Slowest: #{slowest}"
      alg_set -= [slowest]
    end
    puts "Big trim took #{'%.2f' % (Time.now - t1)}"
    puts "[#{alg_set.map(&:name).join(',')}] - #{alg_set.count} algs. . Time #{'%.2f' % (Time.now - t1)}"
    puts "[#{HumanAlg.set_to_ids(alg_set)}]"
  end

  def self.find_slowest_alg(alg_set)
    t1 = Time.now
    baseline = average_best(alg_set)
    results = []
    puts "Baseline: #{baseline}, #{alg_set.count} algs"
    alg_set.each do |alg|
      ab = average_best(alg_set - [alg])
      results << [ab-baseline, alg.name, alg]
    end
    puts results.to_s
    results.sort!

    results.each{ |r| puts r.to_s }
    puts "That took #{'%.2f' % (Time.now - t1)}"
    results.first.last
  end

  class HumanAlg
    attr_reader :name, :ids

    def initialize(alg, mirror_alg)
      @alg = alg
      @name = alg.name
      @ids = (mirror_alg ? [alg.id, mirror_alg.id] : [alg.id])
    end

    def to_s
      "#{@name} #{@alg.length} #{ids}"
    end

    def self.set_to_ids(alg_set)
      [nil] + alg_set.map(&:ids).flatten
    end
  end

  def self.all_human_algs
    result = []

    mirror_algs = {}
    BaseAlg.where(combined: true, root_mirror: true).each do |alg|
      mirror_algs[[alg.root_base_id, alg.root_inverse]] = alg
    end

    BaseAlg.where(combined: true, root_mirror: false).order(:id).each do |alg|
      result << HumanAlg.new(alg, mirror_algs[[alg.root_base_id, alg.root_inverse]])
    end
    result
  end
end