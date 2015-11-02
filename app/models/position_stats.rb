class PositionStats < ActiveRecord::Base
  belongs_to :position

  def self.make(position_id, stats)
    PositionStats.create(position_id: position_id, marshaled_stats: YAML.dump(stats))
  end

  def self.generate_all()
    PositionStats.delete_all

    Position.find_each do |pos|
      PositionStats.make(pos.id, pos.compute_stats)
    end
  end

  def self.aggregate(pos_stats_set)
    count_sums = Hash.new(0)
    pos_stats_set.each {|stat| stat.raw_counts.each{|moves, count| count_sums[moves] += count } }
    OpenStruct.new(
      position_count: pos_stats_set.count,
      shortest: pos_stats_set.map(&:shortest).min || 99,
      fastest:  pos_stats_set.map(&:fastest).min || 99,
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

  def combo_count()
    _stats()[:combo_count]
  end

  def shortest_combo()
    _stats()[:shortest_combo]
  end

  def fastest_combo()
    _stats()[:fastest_combo]
  end

  def _stats()
    @stats ||= YAML.load(marshaled_stats)
  end
end
