class RawAlg < ActiveRecord::Base
  belongs_to :position
  belongs_to :mirror, class_name: 'RawAlg'

  # Populate DB columns
  def self.populate_mirror_id
    update_all do |alg|
      alg.mirror = RawAlg.find_by_b_alg(Algs.mirror(alg.b_alg))
    end
  end

  def self.populate_alg_variants
    update_all { |alg| alg.set_alg_variants }
  end

  def self.populate_positions
    update_all { |alg| alg.set_position }
  end

  def set_alg_variants
    self.r_alg = Algs.rotate_by_U(b_alg)
    self.f_alg = Algs.rotate_by_U(r_alg)
    self.l_alg = Algs.rotate_by_U(f_alg)
  end

  def set_position
    ll_code = Cube.new(b_alg).standard_ll_code # validates
    self.position = Position.by_ll_code(ll_code)
  end

  def set_display_adjustments
    self.display_alg = [:b_alg, :r_alg, :f_alg, :l_alg][-Cube.new(b_alg).standard_ll_code_offset % 4]
    cube = Cube.new(self[display_alg])
    self.u_setup = ('BRFL'.index(cube.piece_at('UB').name[1]) - LL.edge_data(cube.standard_ll_code[1]).distance) % 4
  end

  def self.update_all
    t1 = Time.now
    ActiveRecord::Base.transaction do
      RawAlg.find_each do |alg|
        yield(alg)
        alg.save
      end
    end
    puts "Update done in #{'%.2f' % (Time.now - t1)}"
  end

  # View API
  def css_kind
    'single'
  end

  def moves
    self[display_alg]
  end

  def name
    alg_id
  end

  def oneAlg?
    true
  end

  def setup_moves
    return '' if u_setup == 0 || u_setup.nil?
    "| setupmoves=#{Move.name_from('U', u_setup)}"
  end

end