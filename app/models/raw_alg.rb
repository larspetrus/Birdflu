# frozen_string_literal: true

class RawAlg < ActiveRecord::Base
  belongs_to :position
  belongs_to :mirror, class_name: RawAlg.name
  has_many :combo_algs, foreign_key: :combined_alg_id
  has_many :stars, as: :starrable

  NON_DB_TEXT = 'Not in DB'

  validates :length, presence: true
  validate { errors.add(:specialness, "Save of non DB RawAlg averted") if non_db? }

  before_create do
    set_position
    set_specialness
    set_speed
  end

  NOTHING_ID = 1
  DB_COMPLETENESS_LENGTH = 17

  def self.make(alg, length = 1)
    std_alg = Algs.display_variant(alg)
    RawAlg.create(_moves: Algs.pack(std_alg), u_setup: Algs.standard_u_setup(std_alg), length: length)
  end

  def self.make_non_db(alg)
    packed = Algs.pack(alg)
    fields = {
        _moves: packed,
        length: packed.length,
        u_setup: Algs.standard_u_setup(alg),
        specialness: [Algs.specialness(alg), NON_DB_TEXT].compact.join(' ')
    }
    self.new(fields).tap{|newalg| newalg.set_speed}
  end


  def algs(u_shift)
    [variant(:B), variant(:R), variant(:F), variant(:L)][u_shift]
  end

  def variant(side)
    @variants ||= {}.tap do |variants|
      name = Algs.variant_name(moves)
      4.times do |i|
        variants[Algs.shift(name, i).to_sym] = Algs.shift(moves, i)
      end
    end

    @variants[side.to_sym] || ''
  end

  def speed
    _speed/100.0
  end

  def moves
    Algs.unpack(_moves)
  end

  def star_styles(wca_user_id)
    Galaxy.star_styles_for(wca_user_id, id, 'raw_alg')
  end

  # --- Finders ---
  def self.by_name(name)
    self.find(self.id(name))
  end

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

  def self.find_by_name(name)
    self.find(self.id(name))
  end

  def combo_algs_in(alg_set)
    combo_algs.select{|ca| alg_set.include?(ca) }
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

  # View API
  def presenter(context)
    RawAlgColumns.new(self, context)
  end

  def name
    RawAlg.name_for(id)
  end

  def single?
    true
  end

  def non_db?
    specialness&.end_with? NON_DB_TEXT
  end

  def matches(search_term)
    search_term == id || non_db?
  end

  # Set up a "premove" so the Roofpig colors look like the Position illustration
  def setup_moves(pov_adjustment = 0)
    net_setup = (u_setup + pov_adjustment) % 4

    return '' if net_setup == 0
    "| setupmoves=#{Move.name_from('U', net_setup)}"
  end

  def self.id_ranges
    if @id_ranges.nil? && RawAlg.where(length: 17).maximum(:id) == 46_314_320
      puts "@id_ranges SHORTCUT"
      @id_ranges = [2, 6, 16, 54, 198, 904, 3502, 15340, 70522, 347_930, 1666_938, 8569_752, 43_463_107]
    end
    @id_ranges ||= (6..DB_COMPLETENESS_LENGTH).map{ |l| RawAlg.where(length: l).minimum(:id) }
  end

  def self.name_for(db_id, ranges = self.id_ranges)
    return '-' unless db_id
    lower = ranges.select{|r| r <= db_id }
    return "Nothing" unless lower.present?
    return "" if lower.count + 5 > DB_COMPLETENESS_LENGTH

    "#{('E'.ord + lower.count).chr}#{db_id + 1 - lower.last}"
  end

  def self.id(name, ranges = self.id_ranges)
    return 1 if name == 'Nothing'
    name = name.to_s.upcase

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

  NICK_NAMES = {8=>"Sune", 14=>"Sune", 10=>"AntiSune", 15=>"AntiSune", 9=>"Niklas", 13=>"Niklas", 112=>"Bruno", 169=>"Bruno", 194=>"Allan", 197=>"Allan", 2636=>"Sune²", 1605=>"Sune²", 1874=>"AntiSune²", 2809=>"AntiSune²"}
  def nick_name
    NICK_NAMES[id]
  end

  def to_s
    "#{name}: #{moves}  (id: #{id})"
  end
end