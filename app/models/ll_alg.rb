class LlAlg < ActiveRecord::Base
  self.table_name = "algs"

  belongs_to :position
  belongs_to :alg1, class_name: 'LlAlg'
  belongs_to :alg2, class_name: 'LlAlg'

  before_create do
    self.length = moves.split.length
    ll_code = solves_ll_code # ghetto validation
    self.position = Position.find_or_create_by(ll_code: ll_code) if self.kind == 'combo'
  end

  def m5
    LlAlg.merge_moves(alg1.moves, alg2 ? alg2.moves : '')
  end


  def self.create_combo(a1, a2 = OpenStruct.new(name: '...', moves: '', id: nil))
    mm = merge_moves(a1.moves, a2.moves)
    merged_moves = (mm[0] + mm[2] + mm[4]).join(' ')
    alg_adjustment = 4 - Cube.new.setup_alg(merged_moves).standard_ll_code_offset
    adjusted_moves = rotate_by_U(merged_moves, alg_adjustment)

    ac = Cube.new.setup_alg(adjusted_moves)
    u_setup = ('BRFL'.index(ac.piece_at('UB').name[1]) - LL.edge_data(ac.standard_ll_code[1]).distance) % 4
    LlAlg.create(name: "#{a1.name}+#{a2.name}", moves: adjusted_moves, alg1_id: a1.id, alg2_id: a2.id, kind: 'combo', u_setup: u_setup)
  end

  def self.merge_moves(moves1, moves2)
    start  = moves1.split(' ')

    return [start, [], [], [], []] if moves2.empty?

    finish = moves2.split(' ')
    cancels1 = []
    remains = []
    cancels2 = []

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

    [start, cancels1, remains, cancels2, finish]
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

  def to_s
    "#{@name}: #{@moves}"
  end

  def nl
    "#{length} #{name}"
  end
end
