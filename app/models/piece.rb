# frozen_string_literal: true

class Piece
  attr_reader :name

  ALL = %w[BL BR DB DBL DRB DF DLF DFR DL DR FL FR UB ULB UBR UF UFL URF UL UR] #TODO %i ? ALL_NAMES ?

  CUBE_STATE_CODES = {
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

  Movement = Struct.new(:cycles, :shift)
  MOVEMENTS = {
      R: Movement.new([%i[URF DFR DRB UBR], %i[UR FR DR BR]], {B: :D, D: :F, F: :U, U: :B, L: :L, R: :R}),
      L: Movement.new([%i[ULB DBL DLF UFL], %i[BL DL FL UL]], {B: :U, U: :F, F: :D, D: :B, L: :L, R: :R}),
      F: Movement.new([%i[DLF DFR URF UFL], %i[FL DF FR UF]], {U: :R, R: :D, D: :L, L: :U, F: :F, B: :B}),
      B: Movement.new([%i[ULB UBR DRB DBL], %i[UB BR DB BL]], {U: :L, L: :D, D: :R, R: :U, F: :F, B: :B}),
      U: Movement.new([%i[UBR ULB UFL URF], %i[UR UB UL UF]], {F: :L, L: :B, B: :R, R: :F, U: :U, D: :D}),
      D: Movement.new([%i[DFR DLF DBL DRB], %i[DF DL DB DR]], {F: :R, R: :B, B: :L, L: :F, U: :U, D: :D})
  }

  def self.movement(side)
    MOVEMENTS[side.to_sym]
  end

  def initialize(name)
    raise "'#{name}' is not a valid piece name" unless ALL.include? name

    @name = name
    @stickers = name.chars.map { |char| char.to_sym}
    @on_sides = name.chars.map { |char| char.to_sym}
    @side_count = name.length

    @state_code = CUBE_STATE_CODES[name]
  end

  def shift(movement, turns = 1)
    turns.times do
      @on_sides = @on_sides.map { |on_side| movement.shift[on_side] }
    end
  end

  def rotate(steps)
    @on_sides.rotate!(steps)
  end

  def u_spin(mirror = false)
    raw_spin = @side_count - @on_sides.index(:U)
    (mirror ? -raw_spin : raw_spin) % @side_count
  end

  def sticker_on(side)
    @stickers[@on_sides.index(side.to_sym)]
  end

  def state_on(side)
    @state_code[@on_sides.index(side.to_sym)]
  end

  def as_tweak()
    sides = @on_sides.join
    (@name == sides) ? '' : "#{@name}:#{sides}"
  end

  def state_code_at(position)
    state_on(position[0])
  end

  def f2l_state_code_at(position)
    @name.include?('U') ? '-' : state_on(position[0])
  end

  def is_solved
    solved = true
    @side_count.times { |i| solved &= (@stickers[i] == @on_sides[i]) }
    solved
  end

  def to_s
    stickers = ""
    @side_count.times { |i| stickers += "#{@stickers[i]}@#{@on_sides[i]}, " }
    "name: #{@name},  #{stickers}"
  end
end