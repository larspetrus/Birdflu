# The Positions table contains a static data set of 4608 LL positions. Once initialized, it will never
# change. It could live in memory instead of (or in addition to) the DB, and maybe that's a future feature.
class Position < ActiveRecord::Base
  has_many :combo_algs, -> { order "length, moves, base_alg2_id DESC" }

  belongs_to :best_alg, class_name: 'RawAlg'
  belongs_to :best_combo_alg, class_name: 'ComboAlg'
  belongs_to :main_position, class_name: 'Position'

  has_one :stats, class_name: 'PositionStats'

  validates :ll_code, uniqueness: true # TODO Validate that it's the standard ll_code?

  after_create do
    self.set_filter_names
    self.pov_setup
    self.save
  end

  def algs_in_set(alg_set = AlgSet.active)
    self.combo_algs.where(alg_set.where_clause)
  end

  def self.by_ll_code(ll_code)
    Position.find_by(ll_code: ll_code)
  end

  def as_roofpig_tweaks
    result = []
    4.times do |i|
      c_data = LL.corner_data(ll_code[i*2])
      corner_colors = c_data.position(i).chars.rotate(-c_data.spin).join

      e_data = LL.edge_data(ll_code[i*2 + 1])
      edge_colors = e_data.position(i).chars.rotate(e_data.spin).join

      result << "#{corner_colors}:#{LL.corners[i]}" << "#{edge_colors}:#{LL.edges[i]}"
    end
    result.join(' ')
  end

  def as_cube
    @cube ||= Cube.new(ll_code)
  end

  def has_mirror
    main_position_id != mirror_id
  end

  def mirror
    Position.find(mirror_id)
  end

  def has_inverse
    main_position_id != inverse_id
  end

  def inverse
    Position.find(inverse_id)
  end

  def is_main
    main_position_id == id
  end

  POV_IDS_CACHE = Hash.new{|hash, key| hash[key] = Position.where(main_position_id: key).pluck(:id).freeze }
  def pov_variant_in(selected_ids)
    return self if selected_ids.include?(id)

    Position.find((selected_ids & POV_IDS_CACHE[id]).first)
  end

  def pov_rotations
    POV_IDS_CACHE[main_position_id].select{|pov_id| pov_id != id}
  end

  def display_name
    cop + eo + ep
  end

  def best_combo_alg_length
    best_combo_alg ? best_combo_alg.length : 99
  end

  def best_alg_set_length
    AlgSet.active.shortest(self)
  end

  def best_combo
    combo_algs.first
  end

  def set_mirror_id
    ll_code_obj = LlCode.new(ll_code)
    self.mirror_id = Position.find_by_ll_code(ll_code_obj.mirror).id
  end

  def set_filter_names
    ll_code_obj = LlCode.new(ll_code)

    cop_name = COP_NAMES[ll_code_obj.cop_code]
    self.cop = cop_name
    self.co  = cop_name[0]
    self.cp  = cop_name[1]

    self.oll = OLL_NAMES[ll_code_obj.oll_code]
    self.eo  = EO_NAMES[ll_code_obj.eo_code]
    self.ep  = EP_NAMES[ll_code_obj.ep_code]
  end

  def pov_setup
    if self.main_position_id
      source_pos = Position.find(self.main_position_id)

      self.best_alg_id       = source_pos.best_alg_id
      self.best_combo_alg_id = source_pos.best_combo_alg_id
      self.optimal_alg_length= source_pos.optimal_alg_length
      self.alg_count         = source_pos.alg_count
    else
      self.main_position_id = self.id
      self.pov_offset = 0
    end

  end

  PAUS = {['d',1]=>2, ['d',2]=>0, ['d',3]=>2, ['b',2]=>1, ['l',1]=>3, ['r',2]=>1, ['r',3]=>0}
  def pov_adjust_u_setup
    return 0 if pov_offset == 0 || cp == 'o'

    PAUS[[cp, pov_offset]]
  end

  def self.get_filter_names(lz_code)
    ll_code_obj = LlCode.new(lz_code)

    result = {}
    cop_name = COP_NAMES[ll_code_obj.cop_code] || 'xx' # xx -> invalid orientation.
    result[:cop] = cop_name
    result[:co]  = cop_name[0]
    result[:cp]  = cop_name[1]

    result[:oll] = OLL_NAMES[ll_code_obj.oll_code]
    result[:eo]  = EO_NAMES[ll_code_obj.eo_code]
    result[:ep]  = EP_NAMES[ll_code_obj.ep_code]

    result
  end

  def compute_stats
    {
      raw_counts: RawAlg.where(position_id: main_position_id).group(:length).order(:length).count(),
      shortest:   RawAlg.where(position_id: main_position_id).order(:length, :speed, :alg_id).first().try(:length),
      fastest:    RawAlg.where(position_id: main_position_id).order(:speed, :length, :alg_id).first().try(:speed),
      combo_count:    ComboAlg.where(position_id: main_position_id).count(),
      shortest_combo: ComboAlg.where(position_id: main_position_id).order(:length, :speed, :name).first().try(:length),
      fastest_combo:  ComboAlg.where(position_id: main_position_id).order(:speed, :length, :name).first().try(:speed),
    }
  end

  def matches(search_term)
    false
  end

  def to_s
    "Position #{id} - #{display_name}"
  end

  def self.update_each
    Position.find_each do |pos|
      yield(pos)
      pos.save
    end
  end

  def self.random_id
    @main_pos_ids ||= Position.where("main_position_id = id").pluck(:id)
    @main_pos_ids.sample
  end

  COP_NAMES = {
      aiai: 'Ad',
      aaeo: 'Af',
      aaaa: 'Ao',
      ajpp: 'bb',
      ajbj: 'bd',
      abfp: 'bf',
      affj: 'bl',
      abbb: 'bo',
      afpb: 'br',
      akqq: 'Bb',
      akck: 'Bd',
      acgq: 'Bf',
      aggk: 'Bl',
      accc: 'Bo',
      agqc: 'Br',
      aibk: 'Cd',
      aafq: 'Cf',
      aabc: 'Co',
      aepc: 'Cr',
      aicj: 'Dd',
      aagp: 'Df',
      aacb: 'Do',
      aeqb: 'Dr',
      ajak: 'Ed',
      abeq: 'Ef',
      afek: 'El',
      abac: 'Eo',
      afoc: 'Er',
      bkbk: 'Fd',
      bcfq: 'Ff',
      bgfk: 'Fl',
      bcbc: 'Fo',
      bjck: 'Gd',
      bbgq: 'Gf',
      bbcc: 'Go',
      bfqc: 'Gr',

      aipq: 'Cb',
      aefk: 'Cl',
      aiqp: 'Db',
      aegj: 'Dl',
      ajoq: 'Eb',
      bjqq: 'Gb',
      bfgk: 'Gl',

      # "ghost/pov positions"
      aeei: 'Al',
      aeoa: 'Ar',
      aioo: 'Ab',
      bgpc: 'Fr',
      bkpq: 'Fb',
  }

  OLL_NAMES = {
      a1a1a1a1: :m0,
      a1a1a2a2: :m28,
      a1a1b1c1: :m24,
      a1a1b2c2: :m32,
      a1a1c1b1: :m23,
      a1a1c2b2: :m44,
      a1a2a1a2: :m57,
      a1a2b1c2: :m33,
      a1a2b2c1: :m31,
      a1a2c1b2: :m45,
      a1a2c2b1: :m43,
      a1b1a1c1: :m25,
      a1b1a2c2: :m36,
      a1b1b1b1: :m26,
      a1b1b2b2: :m12,
      a1b1c2a2: :m30,
      a1b2a1c2: :m39,
      a1b2a2c1: :m35,
      a1b2b1b2: :m16,
      a1b2b2b1: :m6,
      a1b2c1a2: :m34,
      a1c1a2b2: :m38,
      a1c1b2a2: :m41,
      a1c1c1c1: :m27,
      a1c1c2c2: :m7,
      a1c2a2b1: :m37,
      a1c2b1a2: :m46,
      a1c2c1c2: :m13,
      a1c2c2c1: :m5,
      a2a2a2a2: :m20,
      a2a2b1c1: :m29,
      a2a2b2c2: :m19,
      a2a2c1b1: :m42,
      a2a2c2b2: :m18,
      a2b1a2c1: :m40,
      a2b1b1b2: :m9,
      a2b1b2b1: :m14,
      a2b2a2c2: :m17,
      a2b2b1b1: :m8,
      a2b2b2b2: :m4,
      a2c1c1c2: :m10,
      a2c1c2c1: :m15,
      a2c2c1c1: :m11,
      a2c2c2c2: :m3,
      b1b1c1c1: :m22,
      b1b1c2c2: :m49,
      b1b2c1c2: :m52,
      b1b2c2c1: :m48,
      b1c1b1c1: :m21,
      b1c1b2c2: :m54,
      b1c1c2b2: :m50,
      b1c2b1c2: :m55,
      b1c2b2c1: :m53,
      b1c2c1b2: :m51,
      b2b2c1c1: :m47,
      b2b2c2c2: :m2,
      b2c1b2c1: :m56,
      b2c2b2c2: :m1,
  }

  EO_NAMES = {'1111'=>'4', '1122'=>'6', '1212'=>'1', '1221'=>'9', '2112'=>'7', '2121'=>'2', '2211'=>'8', '2222'=>'0'}

  EP_NAMES = {'1111'=>'A', '5555'=>'B', '7373'=>'C', '3737'=>'D', '1335'=>'E', '1577'=>'F',
              '5133'=>'G', '7157'=>'H', '3513'=>'I', '7715'=>'J', '3351'=>'K', '5771'=>'L',
              '7777'=>'a', '3333'=>'b', '1515'=>'c', '5151'=>'d', '3711'=>'e', '5735'=>'f',
              '1371'=>'g', '5573'=>'h', '1137'=>'i', '3557'=>'j', '7113'=>'k', '7355'=>'l'}

end
