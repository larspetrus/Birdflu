class ComboAlg < ActiveRecord::Base
  belongs_to :position
  belongs_to :base_alg1, class_name: 'BaseAlg'
  belongs_to :base_alg2, class_name: 'BaseAlg'

  before_create do
    self.moves = Algs.normalize(self.moves)
    self.length = self.moves.split.length
    cube = Cube.new(self.moves)
    ll_code = cube.standard_ll_code # validates
    self.position = Position.by_ll_code(ll_code)
    self.u_setup = ('BRFL'.index(cube.piece_at('UB').name[1]) - LL.edge_data(cube.standard_ll_code[1]).distance) % 4
  end

  def self.make(a1, a2, u_shift)
    return if a1.moves.empty?

    move_parms = merge_moves(a1.moves, a2.moves(u_shift))
    return if move_parms[:moves].empty?

    self.align_moves(move_parms)

    create_parms = {name: "#{a1.name}+#{a2.name}", base_alg1_id: a1.id, base_alg2_id: a2.id, alg2_u_shift: u_shift}
    ComboAlg.create(create_parms.merge(move_parms))
  end

  def self.make_4(a1, a2)
    0.upto(3) { |u_shift| make(a1, a2, u_shift) }
  end

  def self.make_single(alg)
    parms = {name: "- #{alg.name} -", base_alg1_id: alg.id, alg2_u_shift: 0, single: true }
    move_parms = merge_moves(alg.moves, '')
    self.align_moves(move_parms)
    ComboAlg.create(parms.merge(move_parms))
  end

  def self.align_moves(move_parms) # Make the alg make the STANDARD ll_code, so the Roofpig matches the position page image
    alg_adjustment = 4 - Cube.new(move_parms[:moves]).standard_ll_code_offset
    move_parms.keys.each { | key | move_parms[key] = rotate_by_U(move_parms[key], alg_adjustment) }
  end

  def self.merge_moves(moves1, moves2)
    if moves2.empty?
      { mv_start: moves1, mv_cancel1: '', mv_merged: '', mv_cancel2: '', mv_end: '', moves: moves1 }
    else
      start, finish, cancels1, remains, cancels2  = moves1.split(' '), moves2.split(' '), [], [], []
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
      end while Move.same_side(start.last, finish.first) && remains.empty?

      #Did we end up with a "R + L2 + R" case?
      if remains.size == 1 && Move.same_side(start.last, finish.first) && Move.opposite_sides(start.last, remains.first)
        merged_move = Move.merge(start.last, finish.first)
        remains << merged_move if merged_move

        cancels1.insert(0, start.pop)
        cancels2 << finish.shift
      end

      {
        mv_start: start.join(' '),
        mv_cancel1: cancels1.join(' '),
        mv_merged: remains.join(' '),
        mv_cancel2: cancels2.join(' '),
        mv_end: finish.join(' '),
        moves: (start + remains + finish).join(' ')
      }
    end
  end

  def self.rotate_by_U(moves, turns = 1)
    moves.chars.map { |char| (place = 'RFLB'.index(char)) ? 'RFLB'[(place + turns) % 4] : char }.join
  end

  def setup_moves
    return '' if u_setup == 0 || u_setup.nil?
    "| setupmoves=#{Move.name_from('U', u_setup)}"
  end

  def oneAlg?
    not base_alg2
  end

  def css_kind
    return 'single' if single
    return 'one-alg' if oneAlg?
    return ''
  end

  def is_aligned_with_ll_code
    Cube.new(moves).natural_ll_code == position.ll_code
  end

  def to_s
    "#{name}: #{moves}  (id: #{id})"
  end

  def self.sanity_check
    errors = []

    ComboAlg.all.each do |ca|
      unless ca.is_aligned_with_ll_code
        errors << ca.to_s
      end
    end
    errors
  end
end
