# frozen_string_literal: true

module Svg
  def self.tag(tag_data)
    if tag_data[:width]
      hlp.tag(:rect, tag_data)
    elsif tag_data[:points]
      hlp.tag(:polygon, tag_data)
    elsif tag_data[:d]
      hlp.tag(:path, tag_data)
    end
  end
end