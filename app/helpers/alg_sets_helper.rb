module AlgSetsHelper
  def avg_format(avg)
    return '--' unless avg
    '%.3f' % avg
  end

  def fmt_coverage_percent(algset)
    return '--' unless algset.coverage
    "#{100 * algset.coverage/algset.subset_pos_ids.count}%"
  end

  def fmt_coverage_fraction(algset, parens = false)
    return '' if !algset.coverage || algset.full_coverage?
    p1, p2 = (parens ? ['(', ')'] : ['', ''])
    p1 + "#{algset.coverage}/#{algset.subset_pos_ids.count}" + p2
  end

  def fmt_avg_length(algset)
    p1, p2 = (algset.full_coverage? ? ['', ''] : ['(', ')'])
    p1 + ('%.3f' % algset.average_length) + p2
  end

  def fmt_avg_speed(algset)
    p1, p2 = (algset.full_coverage? ? ['', ''] : ['(', ')'])
    p1 + ('%.3f' % algset.average_speed) + p2
  end

  def subset_options
    [['All Positions (3916)', 'all'], ['Oriented Edges (494)', 'eo']]
  end

  def subset_long_name(algset)
    @@long_names ||= {}.tap{|h| subset_options.each { |so| h[so.last] = so.first } }
    @@long_names[algset.subset]
  end

  def fmt_algs(algset)
    return ['(no algs)'] if algset.algs.empty?

    algset.algs.sub("G", "|G").sub("H", "|H").sub("I", "|I").sub("J", "|J").sub("K", "|K").split('|')
  end

  def owner(algset)
    algset.predefined ? 'system' : algset.wca_user&.full_name
  end
end
