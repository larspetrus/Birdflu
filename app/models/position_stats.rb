# frozen_string_literal: true

class PositionStats < ActiveRecord::Base
  belongs_to :position

  def self.make(position_id, stats)
    PositionStats.create!(position_id: position_id, marshaled_stats: YAML.dump(stats))
  end

  def self.generate_all()
    PositionStats.delete_all

    Position.find_each do |pos|
      PositionStats.make(pos.id, pos.compute_stats)
    end
  end

  def self.aggregate(positions)
    unique_stats = positions.reduce({}){|hash, pos| hash[pos.main_position_id] = pos.stats; hash }.values

    count_sums = Hash.new(0)
    unique_stats.each {|stat| stat.raw_counts.each{|moves, count| count_sums[moves] += count } }
    OpenStruct.new(
      position_count: positions.count,
      shortest: unique_stats.map(&:shortest).min || 99,
      fastest:  unique_stats.map(&:fastest).min || 99,
      raw_counts: count_sums,
    )
  end

  def raw_counts()
    _stats()[:raw_counts]
  end

  def shortest()
    _stats()[:shortest]
  end

  def fastest()
    _stats()[:fastest]
  end

  def _stats()
    @stats ||= YAML.load(marshaled_stats)
  end
end
