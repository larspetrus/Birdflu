# frozen_string_literal: true

class AlgSetStats

  def initialize(alg_set)
    @alg_set = alg_set
  end

  def coverage
    @coverage ||= @alg_set.subset_pos_ids.count{|id| lengths[id].present? }
  end

  def lengths
    @lengths ||= begin
      Array.new(Position::MAX_REAL_ID + 1).tap do |result|
        @alg_set.pos_subset.find_each { |pos| result[pos.id] = pos.algs_in_set(@alg_set, sortby: 'length', limit: 1).first&.length }
        result[RawAlg::NOTHING_ID] = 0
      end
    end
  end

  def average_length
    @al ||= @alg_set.pos_subset.reduce(0.0) { |sum, pos| sum + (lengths[pos.id] || 0)*pos.weight }/covered_weight
  end

  def speeds
    @speeds ||= begin
      Array.new(Position::MAX_REAL_ID + 1).tap do |result|
        @alg_set.pos_subset.find_each{|pos| result[pos.id] = pos.algs_in_set(@alg_set, sortby: '_speed', limit: 1).first&.speed }
        result[RawAlg::NOTHING_ID] = 0.0
      end
    end
  end

  def average_speed
    @as ||= @alg_set.pos_subset.reduce(0.0) { |sum, pos| sum + (speeds[pos.id] || 0)*pos.weight }/covered_weight
  end

  def covered_weight
    @cw ||= @alg_set.pos_subset.reduce(0.0) { |sum, pos| sum + (lengths[pos.id].nil? ? 0 : pos.weight)}
  end
end
