class BigIcon
  attr_reader :name, :arrows

  def initialize(cube, arrows)
    @name = ''
    @cube = cube
    @arrows = arrows
  end

  def color_at(sticker_code)
    piece, side = sticker_code.to_s.split('_')
    @cube.css(piece, side)# if piece && side
  end

  def code

  end

  def hidden_field_selector

  end
end
