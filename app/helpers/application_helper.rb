# frozen_string_literal: true

module ApplicationHelper
  def spaced_number(count)
    number_with_delimiter(count, delimiter: "\u2009")
  end
end
