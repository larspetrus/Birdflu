# frozen_string_literal: true

# The Positions table contains a static data set of 4608 LL positions. Once initialized, it will never
# change. It could live in memory instead of (or in addition to) the DB, and maybe that's a future feature.
class Position < ActiveRecord::Base
  belongs_to :best_alg, class_name: RawAlg.name
  belongs_to :main_position, class_name: Position.name

  has_one :stats, class_name: PositionStats.name

  validates :ll_code, uniqueness: true # TODO Validate that it's the standard ll_code?

  after_create do
    self.set_filter_names
    self.pov_setup
    self.save
  end

  def presenter(context)
    PositionColumns.new(self, context)
  end

  def algs_in_set(alg_set = AlgSet.active)
    self.old_combo_algs.where(alg_set.where_clause)
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
