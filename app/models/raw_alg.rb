class RawAlg < ActiveRecord::Base
  belongs_to :position
  belongs_to :mirror, class_name: 'RawAlg'

  validates :alg_id, :length, presence: true

  before_create do
    set_alg_variants
    set_position
    set_display_adjustments
    set_specialness
    set_speed
  end

  def algs(u_shift)
    [b_alg, r_alg, f_alg, l_alg][u_shift]
  end

  # --- Populate DB columns ---
  def self.populate_mirror_id
    update_all("mirror_id") do |alg|
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
    display_variant = [:b_alg, :r_alg, :f_alg, :l_alg][-Cube.new(b_alg).standard_ll_code_offset % 4]
    self.moves = self[display_variant]
    self.u_setup = Algs.u_setup(self[display_variant])
  end

  def set_specialness
    self.specialness = Algs.specialness(b_alg)
  end

  def set_speed
    self.speed = Algs.speed_score(b_alg)
  end

  def self.update_all(description = nil)
    puts "Updating #{description} for all RawAlgs" if description
    t1 = Time.now
    RawAlg.find_each do |alg|
      yield(alg)
      alg.save
    end
    puts "Update #{description} done in #{'%.2f' % (Time.now - t1)}"
  end

  # View API
  def css_kind
    'single'
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

  def to_s
    "#{alg_id}: #{moves}  (id: #{id})"
  end

end