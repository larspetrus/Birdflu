# frozen_string_literal: true

module AlgSetsHelper
  def avg_format(avg)
    return '--' unless avg
    '%.3f' % avg
  end

  def fmt_coverage_percent(algset)
    return '--' unless algset.coverage
    "#{100 * algset.coverage/algset.subset_pos_ids.count}%"
  end

  def fmt_uncovered(algset)
    to_show = 16
    and_more = algset.uncovered_ids.count > to_show ? " + #{algset.uncovered_ids.count - to_show} more" : ""
    algset.uncovered_ids.first(to_show).map{|pos_id| link_to Position.find(pos_id).display_name, "positions/#{pos_id}" }.join(' ').html_safe + and_more
  end

  def fmt_coverage_fraction(algset, parens = false)
    return '' if !algset.coverage || algset.full_coverage?
    parens_if("#{algset.coverage}/#{algset.subset_pos_ids.count}", parens)
  end

  def fmt_avg_length(algset)
    parens_if('%.3f' % (algset.average_length || 0), ! algset.full_coverage?)
  end

  def fmt_avg_speed(algset)
    parens_if('%.3f' % (algset.average_speed || 0), ! algset.full_coverage?)
  end

  def subset_options
    [['All Positions (3916)', 'all'], ['Oriented Edges (494)', 'eo']]
  end

  def subset_long_name(algset)
    @@long_names ||= {}.tap{|h| subset_options.each { |so| h[so.last] = so.first } }
    @@long_names[algset.subset]
  end

  def fmt_algs(algset_algs)
    return '(no algs)' if algset_algs.empty?

    algset_algs
        .sub("G", "|G").sub("H", "|H").sub("I", "|I").sub("J", "|J").sub("K", "|K").sub("L", "|L").split('|')
        .select{|x| x.present?}
        .join('●● ')
  end

  def owner(algset)
    algset.predefined ? 'system' : algset.wca_user&.full_name
  end

  def parens_if(value, yes)
    p1, p2 = (yes ? ['(', ')'] : ['', ''])
    p1 + value + p2
  end
end
