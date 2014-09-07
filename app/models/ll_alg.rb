class LlAlg < ActiveRecord::Base
  self.table_name = "algs"

  belongs_to :position

  before_create do
    self.primary = !!self.primary
    self.length = moves.split.length

    self.position = Position.find_or_create_by(ll_code: solves_ll_code)
  end

  def self.create_combo(alg1, alg2)
    LlAlg.create(name: "#{alg1.name}+#{alg2.name}", moves: merge_moves(alg1.moves, alg2.moves))
  end

  def self.merge_moves(moves1, moves2)
    start  = moves1.split(' ')
    finish = moves2.split(' ')

    begin
      m1 = Move.parse(start.last)
      m2 = Move.parse(finish.first)
      double_cancel = (m1.side == m2.side) && (m1.turns + m2.turns == 4)
      if m1.side == m2.side
        start.delete_at(start.length-1)
        finish.delete_at(0)

        start << Move.from(m1.side, (m1.turns + m2.turns) % 4) unless double_cancel
      end
    end while double_cancel && start.length > 0 && finish.length > 0

    (start + finish).join(' ')
  end

  def solves_ll_code
    Cube.new.setup_alg(moves).standard_ll_code
  end

  def to_s
    "#{@name}: #{@moves}"
  end

  def nl
    "#{length} #{name}"
  end
end
