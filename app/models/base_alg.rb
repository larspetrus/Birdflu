class BaseAlg < ActiveRecord::Base
  belongs_to :position
  belongs_to :root_base, class_name: 'BaseAlg'
  has_many :combo_algs1, class_name: 'ComboAlg', foreign_key: "base_alg1_id"
  has_many :combo_algs2, class_name: 'ComboAlg', foreign_key: "base_alg2_id"

  before_create do # crude validation
    Cube.new(moves_u0).ll_codes
  end

  def self.make(name, moves, base_root_id = nil)
    shifts = [moves]
    3.times { shifts << BaseAlg.rotate_by_U(shifts.last) }

    new_alg = BaseAlg.create(root_base_id: base_root_id, name: name, moves_u0: shifts[0], moves_u1: shifts[1], moves_u2: shifts[2], moves_u3: shifts[3])
    unless base_root_id
      new_alg.update(root_base_id: new_alg.id)
    end
    ComboAlg.make_single(new_alg)
    new_alg
  end

  def self.create_group(name, moves, variants)
    created = []
    variants.each do |variant|
      base_alg_id = created.first.try(:id)
      case variant
        when :a
          created << BaseAlg.make(name, moves, base_alg_id)
        when :Ma
          created << BaseAlg.make("M.#{name}", mirror(moves), base_alg_id)
        when :Aa
          created << BaseAlg.make("A.#{name}", reverse(moves), base_alg_id)
        when :AMa
          created << BaseAlg.make("AM.#{name}", mirror(reverse(moves)), base_alg_id)
        else
          raise "Unknown variant type '#{variant}'"
      end
    end
    created
  end

  def self.mirror(moves)
    mirrored = []
    moves.split(' ').each do |move|
      side = {'R' => 'L', 'L' => 'R'}[move[0]] || move[0]
      turns = {"2" => "2", "'" => ""}[move[1]] || "'"
      mirrored << side+turns
    end
    mirrored.join(' ')
  end

  def self.reverse(moves)
    reversed = []
    moves.split(' ').reverse.each do |move|
      turns = {"2" => "2", "'" => ""}[move[1]] || "'"
      reversed << move[0]+turns
    end
    reversed.join(' ')
  end

  def self.rotate_by_U(moves, turns = 1)
    moves.chars.map { |char| (place = 'RFLB'.index(char)) ? 'RFLB'[(place + turns) % 4] : char }.join
  end

  def length
    moves_u0.split(' ').length
  end

  def moves(u_shift=0)
    [moves_u0, moves_u1, moves_u2, moves_u3][u_shift]
  end

  def to_s
    "#{@name}: #{@moves}"
  end
end
