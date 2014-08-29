class Piece
  attr_reader :name

  def initialize(name)
    unless %w[BL BR DB DBL DRB DF DLF DFR DL DR FL FR UB ULB UBR UF UFL URF UL UR].include? name
      raise "'#{name}' is not a valid piece name"
    end
    @name = name
    @stickers = name.chars.map { |char| char.to_sym}
    @on_sides = name.chars.map { |char| char.to_sym}
  end

  def shift(move_map, turns = 1)
    turns.times do
      @on_sides = @on_sides.map { |on_side| move_map[on_side] }
    end
  end

  def rotate(steps)
    @on_sides.rotate!(steps)
  end

  def sticker_on(side)
    @stickers[@on_sides.index(side)]
  end

  def as_tweak()
    colors = position = ""
    @stickers.length.times do |i|
      colors += @stickers[i].to_s
      position += @on_sides[i].to_s
    end
    "#{colors}:#{position}"
  end

  def is_solved
    solved = true
    @stickers.length.times { |i| solved &= (@stickers[i] == @on_sides[i]) }
    solved
  end

  def to_s
    x = ""
    @stickers.length.times do |i|
      x += "#{@stickers[i]}@#{@on_sides[i]}, "
    end

    "name: #{@name},  #{x}"
  end
end