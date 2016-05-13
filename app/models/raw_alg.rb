class RawAlg < ActiveRecord::Base
  belongs_to :position
  belongs_to :mirror, class_name: 'RawAlg'

  validates :alg_id, :length, presence: true

  before_create do
    set_position
    set_specialness
    set_speed
  end

  def self.make(alg, name, length = 1)
    std_alg = Algs.ll_code_variant(alg)
    RawAlg.create(moves: std_alg, u_setup: Algs.standard_u_setup(std_alg), alg_id: name, length: length)
  end

  def algs(u_shift)
    [variant(:B), variant(:R), variant(:F), variant(:L)][u_shift]
  end

  # --- Populate DB columns ---
  def self.populate_mirror_id
    t1 = Time.now
    RawAlg.where(mirror_id: nil).find_each { |alg| alg.update(mirror_id: alg.find_mirror.id) }
    puts "Update mirror_id done in #{'%.2f' % (Time.now - t1)}"
  end

  def find_mirror
    mirror_variants = %w(B R F L).map{|side| Algs.mirror(variant(side)) }
    RawAlg.where(position_id: position.mirror_id, length: length, moves: mirror_variants).first
  end

  def find_reverse
    reverse_variants = %w(B R F L).map{|side| Algs.reverse(variant(side)) }
    RawAlg.where(position_id: position.inverse_id, length: length, moves: reverse_variants).first
  end

  def set_position
    ll_code = Cube.new(moves).standard_ll_code # validates
    self.position = Position.by_ll_code(ll_code)
  end

  def set_specialness
    self.specialness = Algs.specialness(moves)
  end

  def set_speed
    self.speed = Algs.speed_score(moves)
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

  def self.find_from_moves(moves, position_id)
    std_alg = Algs.ll_code_variant(moves)
    RawAlg.where(moves: std_alg, length: Algs.length(std_alg), position_id: position_id).first
  end

  def variant(side)
    @variants ||= {}.tap do |vs|
      name = Algs.variant(moves)
      4.times do |i|
        vs[Algs.rotate_by_U(name, i).to_sym] = Algs.rotate_by_U(moves, i)
      end
    end

    @variants[side.to_sym]
  end

  # View API
  def css_kind
    'single'
  end

  def name
    alg_id
  end

  def single?
    true
  end

  def matches(search_term)
    search_term == id
  end

  # Set up a "premove" so the Roofpig colors look like the Position illustration
  def setup_moves(pov_adjustment = 0)
    net_setup = (u_setup + pov_adjustment) % 4

    return '' if net_setup == 0
    "| setupmoves=#{Move.name_from('U', net_setup)}"
  end

  def to_s
    "#{alg_id}: #{moves}  (id: #{id})"
  end
end