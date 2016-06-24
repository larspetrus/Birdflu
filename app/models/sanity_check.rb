# frozen_string_literal: true

# Maybe these should really be Rake tasks

module SanityCheck
  CORRECT_CL_MIRROR = {"Ao"=>"Ao", "Ad"=>"Ad", "Af"=>"Af", "bo"=>"Bo", "Bo"=>"bo", "bd"=>"Bd", "Bd"=>"bd", "bb"=>"Bl", "Bl"=>"bb", "bl"=>"Bb", "Bb"=>"bl", "bf"=>"Br", "Br"=>"bf", "br"=>"Bf", "Bf"=>"br", "Co"=>"Co", "Cd"=>"Cd", "Cr"=>"Cl", "Cl"=>"Cr", "Cf"=>"Cf", "Cb"=>"Cb", "Do"=>"Do", "Dd"=>"Dd", "Dr"=>"Dl", "Dl"=>"Dr", "Df"=>"Df", "Db"=>"Db", "Eo"=>"Eo", "Ed"=>"Ed", "Ef"=>"Er", "Er"=>"Ef", "Eb"=>"El", "El"=>"Eb", "Fo"=>"Fo", "Fd"=>"Fd", "Ff"=>"Ff", "Fl"=>"Fl", "Go"=>"Go", "Gd"=>"Gd", "Gf"=>"Gb", "Gb"=>"Gf", "Gl"=>"Gl", "Gr"=>"Gr"}


  def self.positions
    errors = []

    Position.find_each do |pos|
      one_position(errors, pos)
    end

    puts "-"*88, errors
    puts "Position error count: #{errors.size}"
  end

  def self.some_positions(how_many = 100)
    errors = []

    Position.pluck(:id).sample(how_many).each do |pos_id|
      one_position(errors, Position.find(pos_id))
    end

    puts "-"*88, errors
    puts "Position error count: #{errors.size}"
  end

  def self.one_position(errors, pos)
    pos_id = "Position id: #{pos.id}, ll_code: #{pos.ll_code}"
    main_pos = pos.main_position # Ideally mirrors and inverses for ghosts would be the correct ghost

    errors << "Unmatched mirrors: #{pos_id}" if main_pos.id != pos.inverse.inverse_id
    errors << "Unmatched inverse: #{pos_id}" if main_pos.id != pos.mirror.mirror_id

    if CORRECT_CL_MIRROR[main_pos.cop] != pos.mirror.cop
      errors << "Unmatched corner looks '#{main_pos.cop}' <=> '#{pos.mirror.cop}': #{pos_id}"
    end

    bad_pov_offset = pos.is_main ? pos.pov_offset != 0 : ![1, 2, 3].include?(pos.pov_offset)
    errors << "Bad pov_offset: #{pos_id}" if bad_pov_offset

    stats_alg_count = pos.stats._stats[:raw_counts].values.sum
    if pos.alg_count != stats_alg_count
      errors << "Alg count mismatch for #{pos_id}: #{pos.alg_count} != #{stats_alg_count}"
    end
  end

  def self.raw_algs
    result = []
    RawAlg.where('length >= 6').find_each do |alg|
      one_raw_alg(alg, result)
    end
    result
  end

  def self.some_raw_algs(how_many = 100)
    result = []
    id_range = RawAlg.minimum(:id)..RawAlg.maximum(:id)
    checked = 0

    while checked < how_many do
      alg = RawAlg.find_by_id(rand(id_range))
      if alg
        one_raw_alg(alg, result)
        checked += 1
      end
    end
    result
  end


  def self.one_raw_alg(alg, result)
    expected_moves = Algs.display_variant(alg.moves)
    expected_u_setup = Algs.standard_u_setup(expected_moves)

    if alg.u_setup != expected_u_setup || alg.moves != expected_moves
      result << ".moves and/or .u_setup is wrong: #{alg.id}: #{alg.moves} - #{alg.u_setup} Should be:!= #{expected_moves} - #{expected_u_setup})"
    end

    expected_speed = Algs.speed_score(alg.moves)
    if alg.speed != expected_speed
      result << ".speed: #{alg.id}: #{alg.speed} Should be: #{expected_speed}. Diff: #{alg.speed - expected_speed}"
    end
  end

  def self.combo_algs
    errors = []

    ComboAlg.find_each do |ca|
      # Check that moves are the same as the RawAlg
    end
    errors
  end

end
