class Piece
  attr_reader :name

  ALL = %w[BL BR DB DBL DRB DF DLF DFR DL DR FL FR UB ULB UBR UF UFL URF UL UR] #TODO %i ? ALL_NAMES ?

  STATE_CODES = {
      'BL'  => 'ab'.split(''),
      'BR'  => 'cd'.split(''),
      'DB'  => 'ef'.split(''),
      'DBL' => 'ABC'.split(''), 
      'DRB' => 'DEF'.split(''),
      'DF'  => 'gh'.split(''),
      'DLF' => 'GHI'.split(''),
      'DFR' => 'JKL'.split(''),
      'DL'  => 'ij'.split(''),
      'DR'  => 'kl'.split(''),
      'FL'  => 'mn'.split(''),
      'FR'  => 'op'.split(''),
      'UB'  => 'qr'.split(''),
      'ULB' => 'MNO'.split(''),
      'UBR' => 'PQR'.split(''),
      'UF'  => 'st'.split(''),
      'UFL' => 'STU'.split(''),
      'URF' => 'VXY'.split(''),
      'UL'  => 'uv'.split(''),
      'UR'  => 'xy'.split('')
  }
  
  
  def initialize(name)
    raise "'#{name}' is not a valid piece name" unless ALL.include? name

    @name = name
    @stickers = name.chars.map { |char| char.to_sym}
    @on_sides = name.chars.map { |char| char.to_sym}
    @sides = @stickers.count

    @state_code = STATE_CODES[name]
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

  def state_on(side)
    @state_code[@on_sides.index(side.to_sym)]
  end

  def as_tweak()
    colors = @stickers.join
    sides = @on_sides.join

    (colors == sides) ? '' : "#{colors}:#{sides}"
  end

  def for_state(position)
    state_on(position[0])
  end

  def for_f2l_state(position)
    @name.include?('U') ? '-' : state_on(position[0])
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