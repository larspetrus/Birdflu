class ComboAlg < ActiveRecord::Base
  belongs_to :position
  belongs_to :base_alg1, class_name: 'BaseAlg'
  belongs_to :base_alg2, class_name: 'BaseAlg'

  before_create do
    self.length = moves.split.length
    ll_code = solves_ll_code # validates
    self.position = Position.find_by(ll_code: ll_code)
  end

  def self.create_combo(a1, a2, u_shift)
    return if a1.moves.empty?

    move_parms = merge_moves(a1.moves, a2.moves(u_shift))
    alg_adjustment = 4 - Cube.new.setup_alg(move_parms[:moves]).standard_ll_code_offset
    move_parms.keys.each { | key | move_parms[key] = rotate_by_U(move_parms[key], alg_adjustment) }

    ac = Cube.new.setup_alg(move_parms[:moves])
    u_setup = ('BRFL'.index(ac.piece_at('UB').name[1]) - LL.edge_data(ac.standard_ll_code[1]).distance) % 4

    create_parms = {name: "#{a1.name}+#{a2.name}", base_alg1_id: a1.id, base_alg2_id: a2.id, alg2_u_shift: u_shift, u_setup: u_setup}
    ComboAlg.create(create_parms.merge(move_parms))
  end

  def self.merge_moves(moves1, moves2)
    if moves2.empty?
      { mv_start: moves1, mv_cancel1: '', mv_merged: '', mv_cancel2: '', mv_end: '', moves: moves1 }
    else
      start, finish, cancels1, remains, cancels2  = moves1.split(' '), moves2.split(' '), [], [], []
      begin
        m1 = Move.parse(start.last)
        m2 = Move.parse(finish.first)
        if m1.side == m2.side
          cancels1.insert(0, start.last)
          cancels2 << finish.first

          start.delete_at(start.length-1)
          finish.delete_at(0)

          remains << Move.from(m1.side, (m1.turns + m2.turns) % 4) unless m1.turns + m2.turns == 4
        end
      end while m1.side == m2.side && remains.empty? && start.present? && finish.present?

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

  def solves_ll_code
    Cube.new.setup_alg(moves).standard_ll_code
  end

  def setup_moves
    return '' if u_setup == 0 || u_setup.nil?
    "| setupmoves=#{Move.from('U', u_setup)}"
  end

  def oneAlg?
    name.end_with? '+…' # TODO fragile…
  end

  def to_s
    "#{@name}: #{@moves}"
  end
end
