class Piece
  attr_reader :name

  ALL = %w[BL BR DB DBL DRB DF DLF DFR DL DR FL FR UB ULB UBR UF UFL URF UL UR]

  def initialize(name)
    raise "'#{name}' is not a valid piece name" unless ALL.include? name

    @name = name
    @stickers = name.chars.map { |char| char.to_sym}
    @on_sides = name.chars.map { |char| char.to_sym}
    @sides = @stickers.count
  end

  def shift(move_map, turns = 1)
    turns.times do
      @on_sides = @on_sides.map { |on_side| move_map[on_side] }
    end
  end

  def rotate(steps)
    @on_sides.rotate!(steps)
  end

  def u_spin(mirror = false)
    raw_spin = @sides - @on_sides.index(:U)
    (mirror ? -raw_spin : raw_spin) % @sides
  end

  def sticker_on(side)
    @stickers[@on_sides.index(side.to_sym)]
  end

  def as_tweak()
    colors = @stickers.join
    sides = @on_sides.join
    if colors == sides
      ''
    else
      "#{colors}:#{sides}"
    end
  end

  def is_solved
    solved = true
    @sides.times { |i| solved &= (@stickers[i] == @on_sides[i]) }
    solved
  end

  def to_s
    stickers = ""
    @sides.times { |i| stickers += "#{@stickers[i]}@#{@on_sides[i]}, " }
    "name: #{@name},  #{stickers}"
  end
end