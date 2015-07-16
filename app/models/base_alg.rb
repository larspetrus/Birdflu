class BaseAlg < ActiveRecord::Base
  belongs_to :position
  has_one :base_alg1, class_name: 'ComboAlg'
  has_one :base_alg2, class_name: 'ComboAlg'
  has_many :combo_algs1, class_name: 'ComboAlg', foreign_key: "base_alg1_id"
  has_many :combo_algs2, class_name: 'ComboAlg', foreign_key: "base_alg2_id"

  before_create do # crude validation
    Cube.new.setup_alg(moves_u0).ll_codes
  end

  def self.make(name, moves)
    shifts = [moves]
    3.times { shifts << BaseAlg.rotate_by_U(shifts.last) }

    BaseAlg.create(name: name, moves_u0: shifts[0], moves_u1: shifts[1], moves_u2: shifts[2], moves_u3: shifts[3])
  end

  def self.rotate_by_U(moves, turns = 1)
    moves.chars.map { |char| (place = 'RFLB'.index(char)) ? 'RFLB'[(place + turns) % 4] : char }.join
  end

  def moves(u_shift=0)
    [moves_u0, moves_u1, moves_u2, moves_u3][u_shift]
  end

  def to_s
    "#{@name}: #{@moves}"
  end
end
