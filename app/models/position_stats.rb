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
