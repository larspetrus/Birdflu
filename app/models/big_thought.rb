# frozen_string_literal: true

class BigThought

  def self.populate_db()
    initial_run = (Position.count == 0)

    if initial_run
      ActiveRecord::Base.transaction { BigThought.generate_positions }
    end
  end

  def self.combine(new_alg)
    already_combined_ids = ComboAlg.combined_ids
    raise "This alg is already combined: #{new_alg}" if already_combined_ids.include?(new_alg.id)
    raise "Can't combine the empty alg (like this) " if new_alg.id == self.empty_alg&.id

    ComboAlg.make(new_alg, self.empty_alg, 0) if self.empty_alg
    RawAlg.where(id: already_combined_ids).each do |old|
      ComboAlg.make_4(old, new_alg)
      ComboAlg.make_4(new_alg, old)
    end
    ComboAlg.make_4(new_alg, new_alg)
  end

  def self.combine_many(raw_algs)
    timed_transaction do
      raw_algs.each{ |alg| combine(alg) }
    end
  end

  def self.empty_alg
    @empty_alg ||= RawAlg.where(length: 0).first
  end


  # Update Positions table after adding RawAlgs #TODO: make automatic
  def self.update_positions
    alg_counts = RawAlg.group(:position_id).count
    Position.find_each do |pos|
      pos.update(alg_count: alg_counts[pos.id])
    end
  end

  def self.generate_positions(inverses = {}) # All LL positions
    puts "-- (RE)GENERATING POSITIONS --"

    corner_positioning_algs = [
        "",                                    # corners in place
        "R' F R' B2 R F' R' B2 R2",            # three cycle
        "F R' F' L F R F' L2 B' R B L B' R' B" # diagonal swap
    ]

    edge_positioning_algs = [
        "",
        "F2 U R' L F2 R L' U F2",  #Allans
        "F2 U' L R' F2 L' R U' F2",
        "L2 U F' B L2 F B' U L2",
        "L2 U' B F' L2 B' F U' L2",
        "B2 U L' R B2 L R' U B2",
        "B2 U' R L' B2 R' L U' B2",
        "R2 U B' F R2 B F' U R2",
        "R2 U' F B' R2 F' B U' R2",
        "R2 F2 B2 L2 D L2 B2 F2 R2", # Arne
        "F2 B2 D R2 F2 B2 L2 F2 B2 D' F2 B2", # Berts
        "F2 B2 D' R2 F2 B2 L2 F2 B2 D F2 B2",
    ]

    found_positions = Hash.new(0)

    corner_positioning_algs.each do |cp_alg|
      edge_positioning_algs.each do |ep_alg|
        cube = Cube.new(cp_alg).apply_reverse_alg(ep_alg)
        untwisted_ll_code = cube.ll_codes[0].bytes

        (0..2).each do |c1|
          (0..2).each do |c2|
            (0..2).each do |c3|

              (0..1).each do |e1|
                (0..1).each do |e2|
                  (0..1).each do |e3|
                    twists = [c1, e1, c2, e2, c3, e3, (-c1-c2-c3) % 3, (e1+e2+e3) % 2]
                    twisted_code = (0..7).inject(String.new('')) { |code, i| code.concat(untwisted_ll_code[i]+twists[i]) }

                    found_positions[Cube.new(twisted_code).standard_ll_code] += 1
                  end
                end
              end

            end
          end
        end

      end
    end
    found_positions.each { |code, weight| Position.create(ll_code: code, weight: weight) }

    BigThought.create_pov_positions
    Position.update_each do |pos|
      pos.set_mirror_id
      pos.inverse_id = Position.find_by_ll_code(inverses[pos.ll_code.to_sym]).id
    end

    PositionStats.generate_all
  end

  def BigThought.create_pov_positions
    Position.find_each do |pos|
      pos.as_cube.ll_codes.each_with_index do |llc, i|
        ms = LlCode.filter_names(llc)
        missing_pos = !(ms[:cop] == LlCode::NON_STANDARD_COP || Position.exists?(cop: ms[:cop], eo: ms[:eo], ep: ms[:ep]))
        if missing_pos
          Position.create(ll_code: llc, main_position_id: pos.id, pov_offset: 4-i)
        end
      end
    end
  end


  def self.timed_transaction
    t1 = Time.now
    ActiveRecord::Base.transaction do
      yield
    end
    puts "Done in #{'%.2f' % (Time.now - t1)}"
  end

end