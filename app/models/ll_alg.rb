class LlAlg < ActiveRecord::Base
  self.table_name = "algs"

  belongs_to :position
  belongs_to :alg1, class_name: 'LlAlg'
  belongs_to :alg2, class_name: 'LlAlg'

  before_create do
    self.length = moves.split.length
    self.position = Position.find_or_create_by(ll_code: solves_ll_code) unless self.kind == 'generator'
  end

  def self.create_combo(a1, a2)
    LlAlg.create(name: "#{a1.name}+#{a2.name}", moves: merge_moves(a1.moves, a2.moves), alg1: a1, alg2: a2, kind: 'combo')
  end

  def self.merge_moves(moves1, moves2)
    start  = moves1.split(' ')
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

    puts "#{start.join(' ')} [#{cancels1.join(' ')} |#{remains.join(' ')}| #{cancels2.join(' ')}] #{finish.join(' ')}"

    (start + remains + finish).join(' ')
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
