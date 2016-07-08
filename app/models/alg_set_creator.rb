# frozen_string_literal: true

#Toolbox for making AlgSets

class AlgSetCreator
  def self.coverage(human_algs)
    ids = MirrorAlgs.raw_alg_ids_from(human_algs)
    ComboAlg.where(alg1_id: ids, alg2_id: ids).includes(:combined_alg).map{|ca| ca.combined_alg.position_id}.uniq.count
  end

  def self.make_minimal_set()
    t1 = Time.now

    all = all_combined_as_mirror_algs
    start_set = %w(F1·F3 F2·F4 G1·G6 G2·G7 G3·G9 G4·G8 G5·G10)

    alg_set = all.select {|alg| start_set.include?(alg.name) }
    redundant_algs = []
    coverage = coverage(alg_set)
    puts "Starting coverage: #{coverage}  #{coverage/3916.0}%"
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
    puts "[#{MirrorAlgs.raw_alg_ids_from(alg_set)}]"

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
        puts "Full coverage without #{pair.map(&:name)} (#{MirrorAlgs.raw_alg_ids_from(pair)})!"
      end
    end
  end


  def self.average_best(human_algs)
    @@current = MirrorAlgs.raw_alg_ids_from(human_algs)
    Position.all.reduce(0.0) { |sum, pos| sum + pos.best_alg_set_length }/3916
  end

  def self.make_fast_set(size = 50)
    t1 = Time.now

    all = all_combined_as_mirror_algs
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

    alg_set = all_combined_as_mirror_algs.select {|alg| start_set.include?(alg.name) }

    while alg_set.count >= 50
      slowest = find_slowest_alg(alg_set)
      puts "Slowest: #{slowest}"
      alg_set -= [slowest]
    end
    puts "Big trim took #{'%.2f' % (Time.now - t1)}"
    puts "[#{alg_set.map(&:name).join(',')}] - #{alg_set.count} algs. . Time #{'%.2f' % (Time.now - t1)}"
    puts "[#{MirrorAlgs.raw_alg_ids_from(alg_set)}]"
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

  def self.all_combined_as_mirror_algs
    @all_combined_as_mirror_algs ||= MirrorAlgs.make_all(RawAlg.where(id: self.combined_alg_ids).to_a)
  end

  def self.combined_alg_ids
    @combined_alg_ids ||= ComboAlg.distinct.pluck(:alg2_id).sort.freeze
  end
end


