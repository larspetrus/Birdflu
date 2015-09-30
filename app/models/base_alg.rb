class BaseAlg < ActiveRecord::Base
  belongs_to :position
  belongs_to :root_base, class_name: 'BaseAlg'
  has_many :combo_algs1, class_name: 'ComboAlg', foreign_key: "base_alg1_id"
  has_many :combo_algs2, class_name: 'ComboAlg', foreign_key: "base_alg2_id"

  before_create do # crude validation
    Cube.new(moves_u0).ll_codes
  end

  # def self.make(name, moves, base_root_id = nil)
  def self.make(moves, fields = {})
    shifts = [moves]
    3.times { shifts << Algs.rotate_by_U(shifts.last) }

    new_alg = BaseAlg.create(fields.merge(moves_u0: shifts[0], moves_u1: shifts[1], moves_u2: shifts[2], moves_u3: shifts[3]))
    unless fields[:root_base_id]
      new_alg.update(root_base_id: new_alg.id)
    end
    # ComboAlg.make_single(new_alg)
    new_alg
  end

  def self.create_group(name, moves, variants)
    created = []
    variants.each do |variant|
      base_alg_id = created.first.try(:id)
      case variant
        when :a
          created << BaseAlg.make(moves, name: name, root_base_id: base_alg_id)
        when :Ma
          created << BaseAlg.make(Algs.mirror(moves), name: 'M.'+name, root_base_id: base_alg_id, root_mirror: true)
        when :Aa
          created << BaseAlg.make(Algs.reverse(moves), name: 'A.'+name, root_base_id: base_alg_id, root_inverse: true)
        when :AMa
          created << BaseAlg.make(Algs.mirror(Algs.reverse(moves)), name: 'AM.'+name, root_base_id: base_alg_id, root_mirror: true, root_inverse: true)
        else
          raise "Unknown variant type '#{variant}'"
      end
    end
    created
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
