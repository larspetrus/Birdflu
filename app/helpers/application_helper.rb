# frozen_string_literal: true

module ApplicationHelper
  def spaced_number(count)
    number_with_delimiter(count, delimiter: "\u2009") # unicode 2009 is "thin space"
  end

  def alg_sections(alg)
    sections = alg.split(' ').each_slice(4).to_a.map{|slice| slice.join(' ')}
    sections.map.with_index { |slice, i| hlp.content_tag(:span, slice, class: (i.odd? ? :odd : :even)) }
  end

  def hlp
    ActionController::Base.helpers
  end
end
