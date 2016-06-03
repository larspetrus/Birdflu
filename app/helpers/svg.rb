# frozen_string_literal: true

module Svg
  def self.tag(tag_data)
    h = ActionController::Base.helpers

    if tag_data[:width]
        h.tag(:rect, tag_data)
    elsif tag_data[:points]
        h.tag(:polygon, tag_data)
    elsif tag_data[:d]
      h.tag(:path, tag_data)
    end
  end
end