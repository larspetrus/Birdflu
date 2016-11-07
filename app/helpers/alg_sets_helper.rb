module AlgSetsHelper
  def avg_format(avg)
    return '--' unless avg
    '%.3f' % avg
  end

  def fmt_coverage(algset)
    return '--' unless algset.coverage
    algset.full_coverage ? '100%' :  "#{algset.coverage}/#{algset.subset_pos_ids.count - 1}"
  end

  def fmt_avg_length(algset)
    return '--' unless algset.full_coverage
    '%.3f' % algset.average_length
  end

  def fmt_avg_speed(algset)
    return '--' unless algset.full_coverage
    '%.3f' % algset.average_speed
  end

  def subset_options
    [['All Positions (3916)', 'all'], ['Edges Oriented (494)', 'eo']]
  end

  def fmt_algs(algset)
    algset.algs.sub("G", "|G").sub("H", "|H").sub("I", "|I").sub("J", "|J").split('|')
  end
end
