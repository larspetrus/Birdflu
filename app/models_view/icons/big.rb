# frozen_string_literal: true

class Icons::Big
  attr_reader :name, :arrows, :id

  def initialize(position)
    @cube = position.as_cube
    @id = @name = position.ll_code
    @arrows = Icons::Ep.for(position).arrows + Icons::Cp.for(position).arrows
  end

  def color_at(sticker_code)
    piece, side = sticker_code.to_s.split('_')
    @cube.color_css(piece, side)
  end

  def code

  end

  def field

  end

  def is_illustration?
    true
  end

  def css_classes(selected_name, locked)
    'pretty-icon'
  end
end
