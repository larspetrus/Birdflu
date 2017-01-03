# frozen_string_literal: true

class Icons::Eop < Icons::Base

  def initialize(name, eo_icon, ep_icon)
    super(:eop, name.to_sym)

    @colors = eo_icon.colors.map { |k, v| [k, v == 'eo' ? 'eop' : v] }.to_h
    @arrows = ep_icon.arrows
  end

  def base_colors
  end

  def self.by_code(code)
    eo_icon = Icons::Eo.by_code(code[0])
    ep_icon = Icons::Ep.by_code(code[1])
    self.new(code, eo_icon, ep_icon)
  end

  def self.for(position)
    by_code(position.eop)
  end

  def self.grid(factors)
    raise "There is no EOP grid"
  end
end
