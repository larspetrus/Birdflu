class RawAlg < ActiveRecord::Base
  belongs_to :position
  belongs_to :mirror, class_name: 'RawAlg'

  validates :length, presence: true

  before_create do
    set_position
    set_specialness
    set_speed
  end

  def self.make(alg, length = 1)
    std_alg = Algs.ll_code_variant(alg)
    RawAlg.create(moves: std_alg, u_setup: Algs.standard_u_setup(std_alg), length: length)
  end

  def algs(u_shift)
    [variant(:B), variant(:R), variant(:F), variant(:L)][u_shift]
  end

  def speed
    _speed/100.0
  end

  # --- Populate DB columns ---
  def self.populate_mirror_id(for_length)
    alg_set = { mirror_id: nil, length: for_length }
    total = RawAlg.where(alg_set).count
    puts "Populating #{total.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse} mirror IDs"
    ActiveRecord::Base.logger.level = 1

    t1 = Time.now
    update_count = 0
    ActiveRecord::Base.transaction do
      RawAlg.where(alg_set).find_each do |alg|
        alg.update(mirror_id: alg.find_mirror.id)

        update_count += 1
        if update_count % 50_000 == 0
          puts "Set #{update_count} mirror IDs --- #{'%.2f' % (Time.now - t1)}"
        end
      end

    end
    ActiveRecord::Base.logger.level = 0
    duration = (Time.now - t1)
    puts "Update mirror_id done in #{'%.2f' % duration}, #{'%.2f' % (1000*duration/total)}ms / alg"
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
    self._speed = Algs.speed_score(moves, for_db: true)
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
    RawAlg.name_for_id(id)
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

  def self.id_ranges
    @id_ranges ||= (6..RawAlg.maximum(:length)).map{ |l| RawAlg.where(length: l).minimum(:id) }
  end

  def self.name_for_id(db_id, ranges = self.id_ranges)
    lower = ranges.select{|r| r <= db_id }
    lower.present? ? "#{(69 + lower.count).chr}#{db_id + 1 - lower.last}" : 'Nothing'
  end

  def self.id_for_name(name, ranges = self.id_ranges)
    return 1 if name == 'Nothing'

    computed_id = ranges[name.bytes[0] - 70] + name[1..-1].to_i - 1
    self.name_for_id(computed_id, ranges) == name ? computed_id : nil
  rescue
    nil
  end

  def self.find_with_name(name)
    self.find_by_id(self.id_for_name(name))
  end

  def to_s
    "#{name}: #{moves}  (id: #{id})"
  end
end