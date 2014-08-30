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

  def standard_ll_code
    ll_codes.sort.first
  end

  def ll_codes()
    (0..3).map do |i|
      ll_code(LL.corners.rotate(i), LL.edges.rotate(i))
    end
  end

  def ll_code(c_positions, e_positions)
    first_corner_placed_correctly_offset  = c_positions.index(piece_at(c_positions[0]).name)
    corners = c_positions.rotate(first_corner_placed_correctly_offset)
    edges   = e_positions.rotate(first_corner_placed_correctly_offset)

    result = ""
    4.times do |i|
      c_piece = piece_at(c_positions[i])
      c_distance = (corners.index(c_piece.name) - i) % 4

      e_piece = piece_at(e_positions[i])
      e_distance = (edges.index(e_piece.name) - i) % 4

      result += LL.corner_code(c_distance, c_piece.u_spin) + LL.edge_code(e_distance, e_piece.u_spin)
    end
    result
  end

  def apply_position(ll_code)
    c_cyc = []
    e_cyc = []

    4.times do |i|
      c_data = LL.corner_data(ll_code[i*2])
      c_cyc << c_to_here = c_data.position(i).to_sym
      @pcs[c_to_here].shift(MOVES[:D].shift, c_data.distance)
      @pcs[c_to_here].rotate(c_data.spin)

      e_data = LL.edge_data(ll_code[2*i + 1])
      e_cyc << e_to_here = e_data.position(i).to_sym
      @pcs[e_to_here].shift(MOVES[:D].shift, e_data.distance)
      @pcs[e_to_here].rotate(e_data.spin)
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
