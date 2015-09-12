class RawAlg < ActiveRecord::Base
  belongs_to :position
  belongs_to :mirror, class_name: 'RawAlg'

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

  def self.populate_mirror_id
    update_all do |alg|
      mirrored_alg = BaseAlg.normalize(BaseAlg.mirror(alg.b_alg))
      alg.mirror_id = RawAlg.find_by_b_alg(mirrored_alg).id
    end
  end

  def self.populate_alg_variants
    update_all { |alg| alg.set_alg_variants }
  end

  def self.populate_positions
    update_all { |alg| alg.set_position }
  end

  def set_alg_variants
    self.r_alg = BaseAlg.rotate_by_U(b_alg)
    self.f_alg = BaseAlg.rotate_by_U(r_alg)
    self.l_alg = BaseAlg.rotate_by_U(f_alg)
  end

  def set_position
    cube = Cube.new(self.r_alg)
    ll_code = cube.standard_ll_code # validates
    self.position = Position.by_ll_code(ll_code)
  end

  def css_kind
    'single'
  end

  def moves
    b_alg
  end

  def name
    alg_id
  end

  def oneAlg?
    true
  end

end