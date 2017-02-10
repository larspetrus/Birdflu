# frozen_string_literal: true

#Toolbox for making AlgSets

class AlgSetLab

  SUBSET = ['all', 'eo'].last # QnD way to swap...

  def self.coverage(selected_malgs)
    ids = MirrorAlgs.raw_alg_ids_from(selected_malgs)
    AlgSet.new(algs: ids.join(' '), subset: SUBSET).fact.coverage
  end

  def self.new_alg_set(mirror_alg_names)
    mirror_alg_names = mirror_alg_names.map(&:name) if mirror_alg_names.first.respond_to?(:name)
    AlgSet.new(algs: mirror_alg_names.join(' '), subset: SUBSET)
  end

  def self.make_minimal_set
    max_coverage = (SUBSET == 'all' ? 3915.0 : 493.0)

    t1 = Time.now

    # start_set = %w(G3.G9 G4.G8 G5.G10)
    start_set = %w(G3.G9 G4.G8 G5.G10 J252.J470 J44.J45 I129.I137 J266.J538 I120.I125 J51.J56 I28.I88 J112.J409 J260.J467 I20.I68)

    selected_malgs = MirrorAlgs.combineds(start_set)
    redundant_malgs = []
    coverage = coverage(selected_malgs)
    puts "Starting coverage: #{coverage}  #{coverage/max_coverage}%"
    while true do
      best_coverage = coverage
      best_alg = nil

      MirrorAlgs.all_combined.each do |malg|
        unless (selected_malgs+redundant_malgs).include? malg
          c = coverage(selected_malgs + [malg])
          if c > best_coverage
            best_coverage = c
            best_alg = malg
          end
          redundant_malgs << malg if c == coverage
        end
      end
      break unless best_alg

      puts "Adding #{best_alg}. New coverage #{best_coverage}. #{redundant_malgs.size} useless. Time #{duration_to_s(Time.now - t1)}"
      selected_malgs << best_alg
      coverage = best_coverage
    end
    puts "[#{selected_malgs.map(&:name).join(',')}] - #{selected_malgs.count} algs. . Time #{duration_to_s(Time.now - t1)}"
    puts "[#{MirrorAlgs.raw_alg_ids_from(selected_malgs)}]"

    trim_minimal_set(selected_malgs, coverage)
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


  SHORT_BASE = %w(F2.F4 G1.G6 G2.G7 G3.G9 G4.G8 G5.G10 H1.H25 H11.H21 H12.H31 H14.H32 H15.H33 H16.H35 H5.H29 H8.H22 I19.I70 I22.I72 I3.I63 I30.I90 I54.I114 I59.I116 J101.J423 J103.J401 J112.J409 J119.J372 J126.J368 J146.J431 J16.J325 J179.J487 J183.J483 J199.J495 J204.J502 J212.J519 J266.J538 J34.J39 J629.J652 J637.J657 J638.J659 J639.J658 J77.J385 J93.J417 J95.J416 J98.J419 J99.J421 Nothing.--)
  SHORT_ORDERED_TAIL = %w(F1.F3 H3.H28 I55.I110 H2.H27 I58.I115 H6.H30 I57.I112 I49.I105 J144.J429 J148.J434 H4.H26 J150.J435 J82.J390 H9.H23 I28.I88 J263.J532 I12.I77 J628.J651 H17.H36 J78.J387 I23.I71 J132.J371 H10.H20 J275.J550 J219.J528 I5.I6 J211.J517 J289.J560)
  SHORT_NAMES = SHORT_BASE + SHORT_ORDERED_TAIL

  FAST_BASE = %w(F2.F4 G2.G7 G3.G9 G4.G8 G5.G10 H15.H33 H16.H35 H17.H36 H19.H38 H6.H30 H9.H23 I19.I70 I21.I67 I3.I63 I49.I105 I58.I115 I59.I116 J103.J401 J110.J411 J112.J409 J126.J368 J131.J370 J140.J382 J16.J325 J183.J483 J199.J495 J204.J502 J212.J519 J216.J521 J219.J528 J246.J455 J266.J538 J34.J39 J49.J54 J629.J652 J637.J657 J82.J390 J93.J417 J95.J416 J97.J420 J99.J421 Nothing.--)
  FAST_ORDERED_TAIL = %w(F1.F3 G1.G6 H8.H22 H13.H34 J98.J419 I55.I110 J301.J571 H14.H32 I50.I106 J213.J520 J179.J487 J53.J60 J192.J496 J217.J524 I16.I79 J275.J550 J101.J423 H2.H27 J132.J371 J78.J387 H5.H29 J176.J475 J225.J513 H12.H31 J211.J517 J274.J541 I5.I6 I54.I114 J639.J658 J215.J522 I39.I97 I17.I82 I13.I80)
  FAST_NAMES = FAST_BASE + FAST_ORDERED_TAIL

  SLOW_NAMES = %w(I1.I60 I11.I84 I119.I124 I121.I126 I127.I135 I131.I133 I140.I143 I24.I73 I26.I86 I27.I87 I32.I66 I4.I62 I43.I99 I44.I101 I45.I104 I47.I108 I8.I75 I9.I76 J105.J403 J117.J426 J120.J373 J130.J364 J134.J377 J138.J379 J139.J383 J14.J323 J142.J428 J143.J427 J147.J433 J149.J432 J150.J435 J152.J436 J153.J437 J154.J440 J157.J441 J158.J443 J161.J355 J167.J361 J168.J348 J169.J349 J172.J353 J18.-- J189.J481 J19.J330 J193.J497 J194.J498 J195.J493 J197.J492 J200.J499 J201.J500 J208.J507 J210.J523 J222.J529 J233.J447 J236.J450 J243.J452 J254.J461 J255.J462 J260.J467 J261.J557 J269.J536 J285.J553 J289.J560 J295.J573 J298.J567 J299.J566 J303.J572 J304.J582 J305.J580 J308.J575 J32.J37 J329.-- J40.J43 J41.J42 J47.J58 J48.J57 J5.J312 J588.J607 J590.J608 J592.J612 J593.J613 J594.J611 J596.J615 J598.J616 J599.J618 J6.J313 J600.J619 J621.J648 J623.J650 J627.J647 J630.J655 J631.J653 J632.J654 J633.J656 J634.J660 J635.J661 J636.J662 J643.J664 J65.J337 J66.J336 J667.J685 J668.J686 J67.J339 J670.J688 J671.J689 J676.J699 J68.J338 J681.J702 J684.J697 J69.J341 J7.J319 J70.J342 J704.J706 J71.J343 J72.J344 J73.J345 J74.J340 J75.J346 J8.J318 J87.J393 J9.J320 J91.J395 J92.J400)

  EO_MINI = %w(G3.G9 G4.G8 G5.G10 J252.J470 J44.J45 I129.I137 J266.J538 I120.I125 J51.J56 I28.I88 J112.J409 J260.J467 I20.I68 J93.J417)

  EO_FEW_BASE = %w(G3.G9 G5.G10 H10.H20 H4.H26 I120.I125 I20.I68 I54.I114 I59.I116 J119.J372 J146.J431 J240.J459 J252.J470 J253.J471 J264.J533 J266.J538 J93.J417)
  EO_FEW_NEXT = %w(G4.G8 I118.I123 I28.I88 J26.J31 I129.I137 J300.J570 J260.J467 I53.I113 I36.I100 J144.J429 F2.F4 J244.J453 I141.I144 J51.J56 J112.J409 H1.H25 J295.J573 J44.J45 J257.J465 I25.I85 J182.J489 J219.J528 J150.J435 J220.J525)

  EO_FAST_BASE = %w(G3.G9 G4.G8 G5.G10 J252.J470 J44.J45 J93.J417 J219.J528 J264.J533 J286.J555 J241.J460 J20.J331 J234.J448 J198.J494 I50.I106 I59.I116 J146.J431)
  EO_FAST_NEXT = %w(J51.J56 J266.J538 J112.J409 J300.J570 J301.J571 J240.J459 J26.J31 J21.J332 J253.J471 H4.H26 J182.J489 I120.I125 I20.I68 J144.J429 I36.I100 J141.J384 H1.H25 J275.J550 J176.J475 H2.H27 I28.I88 I129.I137 J260.J467 J220.J525)


  def self.find_improvements(measure, start_set_names, useless_names = [])
    ActiveRecord::Base.logger.level = 1
    t1 = Time.now

    malg_set = MirrorAlgs.combineds(start_set_names)

    baseline = new_alg_set(start_set_names)
    puts "---- Optimizing for #{measure} ----"
    puts "Baseline: #{baseline.ids.size}, #{start_set_names.count} algs. Avg speed: #{baseline.fact.average_speed}. Avg length: #{baseline.fact.average_length}"
    puts "Current algs: #{start_set_names}"

    scores = []
    MirrorAlgs.all_combined.each do |malg|
      unless malg_set.include?(malg) || useless_names.include?(malg.name)
        score = new_alg_set(malg_set + [malg]).average(measure)
        score_text = "#{'%.4f' % score}  #{malg.name}   ∆#{'%.3f' % (baseline.average(measure) - score)}"
        scores << score_text
        puts score_text
      end
    end

    puts '-'*88
    puts scores.sort.first(20)

    puts "That took #{self.duration_to_s(Time.now - t1)}"
    ActiveRecord::Base.logger.level = 0
  end

  def self.trim_set(measure, malg_names)
    ActiveRecord::Base.logger.level = 1
    t1 = Time.now

    remaining_malg_names = malg_names
    removed = []
    unremovables = ["Nothing.--"]

    while remaining_malg_names.count > unremovables.count
      worst = find_worst_alg(remaining_malg_names, measure, unremovables)
      puts "Removed worst: #{worst}"
      removed.insert(0, worst.name)
      remaining_malg_names = malg_names - removed
    end
    puts "[#{remaining_malg_names.join(',')}] - #{remaining_malg_names.count} algs. . Time #{self.duration_to_s(Time.now - t1)}"
    puts "removed: #{removed}"
    puts "[#{new_alg_set(remaining_malg_names).ids}]"
    ActiveRecord::Base.logger.level = 0
  end

  def self.find_worst_alg(malg_names, measure, unremovables = [])
    t1 = Time.now

    baseline = new_alg_set(malg_names).average(measure)
    results = []
    puts "Baseline: #{baseline}, #{malg_names.count} algs"

    as_mirror_algs = MirrorAlgs.combineds(malg_names)
    as_mirror_algs.each do |malg|
      unless unremovables.include?(malg.name)
        reduced_set = new_alg_set(as_mirror_algs - [malg])
        unremovables << malg.name if reduced_set.average(measure) > 50
        putc '.'
        results << [reduced_set.average(measure)-baseline, malg.name, malg]
      end
    end
    puts "\nLeast useful in set:"
    results.sort!
    results.each { |r| puts "#{'%.4f' % r[0]} - #{r[1]}"}

    puts "That took #{self.duration_to_s(Time.now - t1)}"
    results.first.last
  end

  def self.duration_to_s(total_seconds)
    hours = (total_seconds / 3600).round
    minutes = (total_seconds.round % 3600)/60
    seconds = total_seconds % 60

    decimals = total_seconds < 10 ? '%.4f' : '%.2f'

    [hours > 0 ? "#{hours}h " : '', minutes > 0 ? "#{minutes}m " : '', decimals % seconds, 's'].join
  end
end

