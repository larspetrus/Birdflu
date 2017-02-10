# frozen_string_literal: true

class AlgSetFact < ActiveRecord::Base
  attr_accessor :alg_set

  def self.find_or_create_empty(alg_set)
    AlgSetFact.find_or_create_by(algs_code: alg_set.set_code).tap do |fact|
      fact.alg_set = alg_set
      alg_set.alg_set_fact_id = fact.id
    end
  end

  def data_only
    @data_only = true
  end

  def fully_computed?
    self._avg_length.present? && self._avg_speed.present? && self._coverage.present? && !self._uncovered_ids.nil?
  end

  def compute
    average_length
    average_speed
    coverage
    uncovered_ids
    self
  end


  def coverage
    return self._coverage if @data_only
    self._coverage ||= @alg_set.subset_pos_ids.count{|id| lengths[id].present? }
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
    return self._avg_length if @data_only
    self._avg_length ||= @alg_set.pos_subset.reduce(0.0) { |sum, pos| sum + (lengths[pos.id] || 0)*pos.weight }/covered_weight
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
    return self._avg_speed if @data_only
    self._avg_speed ||= @alg_set.pos_subset.reduce(0.0) { |sum, pos| sum + (speeds[pos.id] || 0)*pos.weight }/covered_weight
  end

  def uncovered_ids
    return self._uncovered_ids if @data_only
    self._uncovered_ids ||= unc_text
  end

  TOO_MANY_UNCOVERED = "(too many)"
  def unc_text
    actual_uncovered_ids = @alg_set.subset_pos_ids.select { |id| lengths[id].nil? }.map(&:to_i)
    (actual_uncovered_ids.count > 50) ? TOO_MANY_UNCOVERED : actual_uncovered_ids.join(' ')
  end

  def covered_weight
    @cw ||= @alg_set.pos_subset.reduce(0.0) { |sum, pos| sum + (lengths[pos.id].nil? ? 0 : pos.weight)}
  end
end
