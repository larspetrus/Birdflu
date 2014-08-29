class Cube
  Move = Struct.new(:cycles, :shift)

  MOVES = {
    R: Move.new([%i[URF DFR DRB UBR], %i[UR FR DR BR]], {B: :D, D: :F, F: :U, U: :B, L: :L, R: :R}),
    L: Move.new([%i[ULB DBL DLF UFL], %i[BL DL FL UL]], {B: :U, U: :F, F: :D, D: :B, L: :L, R: :R}),
    F: Move.new([%i[DLF DFR URF UFL], %i[FL DF FR UF]], {U: :R, R: :D, D: :L, L: :U, F: :F, B: :B}),
    B: Move.new([%i[ULB UBR DRB DBL], %i[UB BR DB BL]], {U: :L, L: :D, D: :R, R: :U, F: :F, B: :B}),
    U: Move.new([%i[UBR ULB UFL URF], %i[UR UB UL UF]], {F: :L, L: :B, B: :R, R: :F, U: :U, D: :D}),
    D: Move.new([%i[DFR DLF DBL DRB], %i[DF DL DB DR]], {F: :R, R: :B, B: :L, L: :F, U: :U, D: :D}),
  }

  def initialize()
    @pcs = { }

    %W[BL BR DB DBL DRB DF DLF DFR DL DR FL FR UB ULB UBR UF UFL URF UL UR].each do |piece|
      @pcs[piece.to_sym] = Piece.new(piece)
    end
  end

  def sticker_at(position, side)
    piece_at(position).sticker_on(side.to_sym)
  end

  def piece_at(position)
    @pcs[position.to_sym]
  end

  def move(side, turns)
    move = MOVES[side]
    turns.times do
      move.cycles.each do |cyc|
        cyc.each { |position| @pcs[position].shift(move.shift) }
        @pcs[cyc[0]], @pcs[cyc[1]], @pcs[cyc[2]], @pcs[cyc[3]] = @pcs[cyc[1]], @pcs[cyc[2]], @pcs[cyc[3]], @pcs[cyc[0]]
      end
    end
  end

  def setup_alg(moves)
    moves.split(' ').reverse.each do |move|
      turns = {"2" => 2, "'" => 1}[move[1]] || 3
      move(move[0].to_sym, turns)
    end
  end

  C_POSITIONS = %w[ULB UBR URF UFL]
  E_POSITIONS   = %w[UB UR UF UL]

  C_CODES = %w[abc efg ijk opq]
  E_CODES = %w[12 34 56 78]

  def standard_fl_code
    fl_codes.sort.first
  end

  def fl_codes()
    (0..3).map do |i|
      fl_code(C_POSITIONS.rotate(i), E_POSITIONS.rotate(i))
    end
  end

  def fl_code(c_positions, e_positions)
    first_corner_placed_correctly_offset  = c_positions.index(piece_at(c_positions[0]).name)
    corners = c_positions.rotate(first_corner_placed_correctly_offset)
    edges   = e_positions.rotate(first_corner_placed_correctly_offset)

    result = ""
    4.times do |i|
      c_piece = piece_at(c_positions[i])
      c_distance = (corners.index(c_piece.name) - i + 4) % 4

      e_piece = piece_at(e_positions[i])
      e_distance = (edges.index(e_piece.name) - i + 4) % 4

      result += C_CODES[c_distance][c_piece.u_spin] + E_CODES[e_distance][e_piece.u_spin]
    end
    result
  end

  C_PLACE= { a:0, b:0, c:0, e:1, f:1, g:1, i:2, j:2, k:2, o:3, p:3, q:3}
  C_SPIN = { a:0, e:0, i:0, o:0, b:2, f:2, j:2, p:2, c:1, g:1, k:1, q:1}

  def apply_position(fl_code)
    c_cyc = []
    e_cyc = []

    4.times do |i|
      c_code = fl_code[2*i].to_sym
      c_distance = C_PLACE[c_code]
      c_cyc << c_move_here = C_POSITIONS[(c_distance + i) % 4].to_sym
      @pcs[c_move_here].shift(MOVES[:D].shift, c_distance)
      @pcs[c_move_here].rotate(3 - C_SPIN[c_code])

      e_code = fl_code[2*i + 1].to_i
      e_distance = (e_code-1)/2
      e_cyc << e_move_here = E_POSITIONS[(e_distance + i) % 4].to_sym
      @pcs[e_move_here].shift(MOVES[:D].shift, e_distance)
      @pcs[e_move_here].rotate(e_code.even? ? 1 : 0)
    end

    @pcs[:ULB], @pcs[:UBR], @pcs[:URF], @pcs[:UFL] = @pcs[c_cyc[0]], @pcs[c_cyc[1]], @pcs[c_cyc[2]], @pcs[c_cyc[3]]
    @pcs[:UB],  @pcs[:UR],  @pcs[:UF],  @pcs[:UL]  = @pcs[e_cyc[0]], @pcs[e_cyc[1]], @pcs[e_cyc[2]], @pcs[e_cyc[3]]

    self
  end

  def as_tweaks()
    @pcs.values.map(&:as_tweak).join(' ')
  end

  def corruption()
    badness = []
    @pcs.each do |position, piece|
      piece_sides = (piece.instance_variable_get :@on_sides).map(&:to_s).sort.join
      if (position.to_s.split('').sort.join != piece_sides)
        badness << "Piece on #{position} thinks it's on #{piece_sides}"
      end
    end
    badness
  end

  def print
    @pcs.each { |pos, piece| puts "At #{pos}: #{piece.to_s}" }
  end
end
