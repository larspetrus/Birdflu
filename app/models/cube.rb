class Cube
  def initialize(state = nil)
    @pieces = { }
    Piece::ALL.each { |piece| @pieces[piece.to_sym] = Piece.new(piece) }

    if state
      is_ll_code = state.length == 8 && (not state.include? ' ')

      if is_ll_code
        apply_position(state)
      else
        apply_alg(state)
      end
    end
  end

  def apply_position(ll_code)
    c_cyc = []
    e_cyc = []

    4.times do |i|
      c_data = LL.corner_data(ll_code[i*2])
      c_cyc << c_to_here = c_data.position(i).to_sym
      @pieces[c_to_here].shift(Move::D.shift, c_data.distance)
      @pieces[c_to_here].rotate(c_data.spin)

      e_data = LL.edge_data(ll_code[2*i + 1])
      e_cyc << e_to_here = e_data.position(i).to_sym
      @pieces[e_to_here].shift(Move::D.shift, e_data.distance)
      @pieces[e_to_here].rotate(e_data.spin)
    end

    @pieces[:ULB],@pieces[:UBR],@pieces[:URF],@pieces[:UFL] = @pieces[c_cyc[0]],@pieces[c_cyc[1]],@pieces[c_cyc[2]],@pieces[c_cyc[3]]
    @pieces[:UB], @pieces[:UR], @pieces[:UF], @pieces[:UL]  = @pieces[e_cyc[0]],@pieces[e_cyc[1]],@pieces[e_cyc[2]],@pieces[e_cyc[3]]

    self
  end

  def apply_alg(moves)
    moves.split(' ').reverse.each do |move|
      move(move[0], 4 - Move.turns(move))
    end
    self
  end

  def sticker_at(position, side)
    piece_at(position).sticker_on(side.to_sym)
  end

  def color_at(position, side) # Same as RoofPig
    {R: '#0d0', L: '#07f', F: 'red', B: 'orange', U: 'yellow', D: '#eee'}[piece_at(position).sticker_on(side).to_sym]
  end

  def css(position, on_side) # Same as RoofPig
    return 'u-color' unless on_side

    side = piece_at(position).sticker_on(on_side).to_s.downcase
    "#{side}-color"
  end

  def piece_at(position)
    @pieces[position.to_sym]
  end

  def move(side, turns)
    move = Move.on(side)
      move.cycles.each do |cyc|
        cyc.each { |position| @pieces[position].shift(move.shift, turns) }
        turns.times { @pieces[cyc[0]],@pieces[cyc[1]],@pieces[cyc[2]],@pieces[cyc[3]] = @pieces[cyc[1]],@pieces[cyc[2]],@pieces[cyc[3]],@pieces[cyc[0]] }
    end
  end

  def standard_ll_code(mirror = false)
    LlCode.pick_official_code(ll_codes(mirror))
  end

  def natural_ll_code
    ll_codes.first
  end

  def standard_ll_code_offset
    ll_codes.index(standard_ll_code)
  end

  def ll_codes(mirror = false)
    raise "Can't make LL code with F2L unsolved" unless f2l_solved()

    corners = LL.corners
    edges = LL.edges
    if mirror
      corners = corners.reverse
      edges = edges.reverse.rotate(1)
    end

    (0..3).map { |i| ll_code(corners.rotate(i), edges.rotate(i), mirror) }
  end

  def ll_code(c_positions, e_positions, mirror = false)
    first_corner_placed_correctly_offset  = c_positions.index(piece_at(c_positions[0]).name)
    corners = c_positions.rotate(first_corner_placed_correctly_offset)
    edges   = e_positions.rotate(first_corner_placed_correctly_offset)

    result = ""
    4.times do |i|
      c_piece = piece_at(c_positions[i])
      c_distance = (corners.index(c_piece.name) - i) % 4

      e_piece = piece_at(e_positions[i])
      e_distance = (edges.index(e_piece.name) - i) % 4

      result += LL.corner_code(c_distance, c_piece.u_spin(mirror)) + LL.edge_code(e_distance, e_piece.u_spin)
    end
    result
  end

  def as_tweaks()
    @pieces.values.map(&:as_tweak).join(' ')
  end

  def corruption()
    badness = []
    @pieces.each do |position, piece|
      piece_sides = (piece.instance_variable_get :@on_sides).map(&:to_s).sort.join
      if position.to_s.split('').sort.join != piece_sides
        badness << "Piece on #{position} thinks it's on #{piece_sides}"
      end
    end
    badness
  end

  def f2l_solved()
    @pieces.values.each do |piece|
      return false if !piece.name.include?('U') && !piece.is_solved
    end
    true
  end

  def print
    @pieces.each { |pos, piece| puts "At #{pos}: #{piece.to_s}" }
  end
end
