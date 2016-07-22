# frozen_string_literal: true

class RawAlg < ActiveRecord::Base
  belongs_to :position
  belongs_to :mirror, class_name: RawAlg.name
  has_many :combo_algs, foreign_key: :combined_alg_id

  validates :length, presence: true

  before_create do
    set_position
    set_specialness
    set_speed
  end

  NOTHING_ID = 1

  def self.make(alg, length = 1)
    std_alg = Algs.display_variant(alg)
    RawAlg.create(_moves: Algs.pack(std_alg), u_setup: Algs.standard_u_setup(std_alg), length: length)
  end

  def presenter(context)
    RawAlgColumns.new(self, context)
  end


  def algs(u_shift)
    [variant(:B), variant(:R), variant(:F), variant(:L)][u_shift]
  end

  def speed
    _speed/100.0
  end

  def moves
    Algs.unpack(_moves)
  end

  # --- Finders ---
  def find_mirror
    db_alg = Algs.pack(Algs.display_variant(Algs.mirror(moves)))
    RawAlg.where(position_id: position.mirror_id, _speed: _speed, length: length, _moves: db_alg).first
  end

  def find_reverse
    db_alg = Algs.pack(Algs.display_variant(Algs.reverse(moves)))
    reverse_speed = Algs.speed_score(Algs.reverse(moves), for_db: true)
    RawAlg.where(position_id: position.inverse_id, _speed: reverse_speed, length: length, _moves: db_alg).first
  end

  def self.find_from_moves(moves, position_id = nil)
    position_id ||= Position.by_ll_code(Cube.new(moves).standard_ll_code).id
    db_speed = Algs.speed_score(moves, for_db: true)
    db_alg = Algs.pack(Algs.display_variant(moves))
    RawAlg.where(position_id: position_id, _speed: db_speed, length: db_alg.length, _moves: db_alg).first
  end

  def self.by_name(name)
    self.find(self.id(name))
  end

  # --- Populate DB columns ---
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

  def variant(side)
    @variants ||= {}.tap do |vs|
      name = Algs.variant(moves)
      4.times do |i|
        vs[Algs.shift(name, i).to_sym] = Algs.shift(moves, i)
      end
    end

    @variants[side.to_sym] || ''
  end

  # View API
  def name
    RawAlg.name_for(id)
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
    if @id_ranges.nil? && RawAlg.maximum(:id) == 46321380
      puts "@id_ranges SHORTCUT"
      @id_ranges = [2, 6, 16, 54, 198, 904, 3502, 15340, 70522, 347930, 1666938, 8569752, 43463107, 43524744, 43525777]
    end
    @id_ranges ||= (6..RawAlg.maximum(:length)).map{ |l| RawAlg.where(length: l).minimum(:id) }
  end

  def self.name_for(db_id, ranges = self.id_ranges)
    lower = ranges.select{|r| r <= db_id }
    lower.present? ? "#{('E'.ord + lower.count).chr}#{db_id + 1 - lower.last}" : 'Nothing'
  end

  def self.id(name, ranges = self.id_ranges)
    name = name.to_s
    return 1 if name == 'Nothing'

    computed_id = ranges[name.bytes[0] - 'F'.ord] + name[1..-1].to_i - 1
    self.name_for(computed_id, ranges) == name ? computed_id : nil
  rescue
    nil
  end

  def ui_alg
    UiAlg.new(moves)
  end

  def db_alg
    DbAlg.new(_moves)
  end

  def to_s
    "#{name}: #{moves}  (id: #{id})"
  end
end