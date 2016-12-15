# frozen_string_literal: true

# The Positions table contains a static data set of 4608 LL positions. Once initialized, it will never
# change. It could live in memory instead of (or in addition to) the DB, and maybe that's a future feature.
#
# While there are 4608 distinct positions in our co/cp/eo/ep model, there are really only 3916 distinct positions.
# The other 692 are rotational variations. We handle this by appointing one of the variations the "main_position",
# that the others refer to through main_position_id, with the rotation defined in pov_offset.
class Position < ActiveRecord::Base
  belongs_to :best_alg, class_name: RawAlg.name
  belongs_to :main_position, class_name: Position.name
  has_one :stats, class_name: PositionStats.name

  scope :real, -> { where(pov_offset: 0) }

  validates :ll_code, uniqueness: true

  after_create do
    self.set_filter_names
    self.pov_setup
    self.save
  end

  MAX_REAL_ID = 3916

  def presenter(context)
    PositionColumns.new(self, context)
  end

  def algs_in_set(alg_set, sortby: Fields::SORTBY.default, limit: Fields::LINES.default.to_i)
    RawAlg.joins(:combo_algs)
    .where('combo_algs.alg1_id' => alg_set.ids, 'combo_algs.alg2_id' => alg_set.ids, 'combo_algs.position_id' => main_position_id)
    .distinct
    .order(sortby)
    .limit(limit)
    .to_a
  end

  def self.by_ll_code(ll_code)
    Position.find_by(ll_code: ll_code)
  end

  def self.by_moves(moves)
    Position.by_ll_code(Cube.new(moves).standard_ll_code)
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
  def pov_variant_in(alternate_ids)
    return self if alternate_ids&.include?(id) || alternate_ids.blank?

    Position.find((alternate_ids & POV_IDS_CACHE[id]).first)
  end

  def pov_rotations
    POV_IDS_CACHE[main_position_id].select{|pov_id| pov_id != id}
  end

  def display_name
    cop + eo + ep
  end

  def eop
    eo + ep
  end

  def set_mirror_id
    ll_code_obj = LlCode.new(ll_code)
    self.mirror_id = Position.find_by_ll_code(ll_code_obj.mirror).id
  end

  def set_filter_names
    LlCode.filter_names(ll_code, self)
  end

  def pov_setup
    if self.main_position_id
      source_pos = Position.find(self.main_position_id)

      self.best_alg_id       = source_pos.best_alg_id
      self.optimal_alg_length= source_pos.optimal_alg_length
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

  def compute_stats
    algs_query = RawAlg.where(position_id: main_position_id)
    {
      raw_counts: algs_query.group(:length).order(:length).count(),
      shortest:   algs_query.minimum(:length) || 0,
      fastest:    (algs_query.minimum(:_speed) || 0 )/100.0,
    }
  end

  def matches(search_term)
    false
  end

  NICK_NAMES = {491=>'H Perm',59=>'Ub Perm',275=>'Ua Perm',549=>'Z Perm',663=>'Aa Perm',2607=>'Ab Perm',3255=>'E Perm',3039=>'F Perm',2391=>'Ga Perm',1527=>'Gb Perm',1095=>'Gc Perm',1959=>'Gd Perm',1743=>'Ja Perm',2175=>'Jb Perm',3859=>'Na Perm',3801=>'Nb Perm',1311=>'Ra Perm',879=>'Rb Perm',2823=>'T Perm',3369=>'V Perm',3585=>'Y Perm'}
  def nick_name
    NICK_NAMES[main_position_id]
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

  def self.random_id(subset = 'all')
    @pos_ids ||= {
        all: Position.real.pluck(:id),
        eo:  Position.real.where(eo: '4').pluck(:id)
    }
    @pos_ids[subset.to_sym].sample
  end

  # Update positions with optimal RawAlgs data. Expects algs to exist for all positions.
  def self.set_best_algs
    puts "Computing Position.best_alg_id, Position.optimal_alg_length"
    BigThought.timed_transaction do
      Position.find_each do |pos|
        optimal_alg = RawAlg.where(position_id: pos.main_position_id).order([:length, :speed, :id]).limit(1).first
        pos.update(best_alg_id: optimal_alg.id, optimal_alg_length: optimal_alg.length)
      end
    end
  end

  # Update positions with optimal RawAlgs data. Expects algs to exist for all positions.
  def self.initialize_positions_inverse
    puts "Initializing Position: inverse_id"
    BigThought.timed_transaction do
      Position.find_each do |pos|
        inverse_ll_code = Cube.new(Algs.reverse(pos.best_alg.moves)).standard_ll_code
        pos.update(inverse_id: Position.find_by_ll_code(inverse_ll_code).id)
      end
    end
  end

end
