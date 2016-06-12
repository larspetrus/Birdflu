# frozen_string_literal: true

class OldComboAlg < ActiveRecord::Base
  belongs_to :position
  belongs_to :base_alg1, class_name: 'RawAlg'
  belongs_to :base_alg2, class_name: 'RawAlg'

  before_create do
    self.moves = Algs.normalize(self.moves)
    self.length = self.moves.split.length
    cube = Cube.new(self.moves)
    ll_code = cube.standard_ll_code # validates
    self.position = Position.by_ll_code(ll_code)
    self.u_setup = Algs.standard_u_setup(self.moves)
    self._speed = Algs.speed_score(self.moves, for_db: true)
  end

  def self.make(a1, a2, u_shift = 0)
    return if a1.length == 0 || a2.length == 0

    move_parms = merge_moves(Algs.official_variant(a1.moves), a2.algs(u_shift))
    return if move_parms[:moves].empty? # algs cancelled

    self.align_moves(move_parms)

    create_parms = {name: "#{a1.name}+#{a2.name}", base_alg1_id: a1.id, base_alg2_id: a2.id, alg2_u_shift: u_shift}
    OldComboAlg.create(create_parms.merge(move_parms))
  end

  def self.make_4(a1, a2)
    0.upto(3) { |u_shift| make(a1, a2, u_shift) }
  end

  def self.align_moves(move_parms) # Make the alg make the STANDARD ll_code, so the Roofpig matches the position page image
    alg_adjustment = Algs.display_offset(move_parms[:moves])
    move_parms.keys.each { | key | move_parms[key] = Algs.rotate_by_U(move_parms[key], alg_adjustment) }
  end

  def self.reconstruct_merge(alg1, alg2, alg2_shift, cancel_count, merge_count)
    ua1 = UiAlg.new(Algs.official_variant(alg1.moves))
    ua2 = UiAlg.new(Algs.rotate_by_U(alg2.moves, alg2_shift))
    da1, da2 = ua1.db_alg, ua2.db_alg

    untouched1, cancel1 = da1[0...-cancel_count], da1[-cancel_count..-1]
    cancel2, untouched2 = da2[0...cancel_count], da2[cancel_count..-1]

    to_merge = Algs.unpack(cancel1.to_s.first(merge_count)+cancel2.to_s.last(merge_count)).split(' ').sort
    merged = UiAlg.new((0...merge_count).map { |i| Move.merge(to_merge[2*i], to_merge[2*i+1]) }.join(' ')).db_alg

    display_offset = Algs.display_offset(ua1 + ua2)
    [untouched1, cancel1, merged, cancel2, untouched2].map{|da| Algs.rotate_by_U(da.ui_alg, display_offset) }
  end

  def self.merge_moves(alg1, alg2)
    start, finish = Algs.normalize(alg1).split(' '), Algs.anti_normalize(alg2).split(' ')
    cancels1, remains, cancels2 = [], [], []

    begin
      if Move.same_side(start.last, finish.first)
        merged_move = Move.merge(start.last, finish.first)
        remains << merged_move if merged_move

        cancels1.insert(0, start.pop)
        cancels2 << finish.shift
      else
        # For cases like "R L + R", flip to "L R + R", and run through again.
        if Move.opposite_sides(start.last, finish.first)
            if Move.opposite_sides(start[-1], start[-2])
              start[-1], start[-2] = start[-2], start[-1]
            elsif Move.opposite_sides(finish[0], finish[1])
              finish[0], finish[1] = finish[1], finish[0]
            end
        end
      end
    end while Move.same_side(start.last, finish.first) && (remains.empty? || Move.opposite_sides(start.last, remains[0]))

    {
      mv_start:  Algs.normalize(start.join(' ')),
      mv_cancel1:Algs.normalize(cancels1.join(' ')),
      mv_merged: Algs.normalize(remains.join(' ')),
      mv_cancel2:Algs.normalize(cancels2.join(' ')),
      mv_end:    Algs.normalize(finish.join(' ')),
      moves:     Algs.normalize((start + remains + finish).join(' '))
    }
  end

  def setup_moves
    return '' if u_setup == 0 || u_setup.nil?
    "| setupmoves=#{Move.name_from('U', u_setup)}"
  end

  def single?
    false
  end

  def css_kind
    'combo'
  end

  def is_aligned_with_ll_code
    Cube.new(moves).natural_ll_code == position.ll_code
  end

  def to_s
    "#{name}: #{moves}  (id: #{id})"
  end

  def speed
    _speed/100.0
  end

end
