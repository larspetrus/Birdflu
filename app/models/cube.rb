class Cube
  def initialize(state = nil)
    @pieces = { }
    Piece::ALL.each { |piece| @pieces[piece.to_sym] = Piece.new(piece) }

    if state
      is_ll_code = state.length == 8 && (not state.include? ' ')

      if is_ll_code
        apply_position(state)
      else
        apply_reverse_alg(state)
      end
    end
  end

  def state_string
    rr = []
    Piece::ALL.each { |piece| rr << piece_at(piece.to_sym).for_state(piece) }
    rr.join(' ')
  end

  def f2l_state_string
    rr = []
    Piece::ALL.each { |pos| rr << piece_at(pos.to_sym).for_f2l_state(pos) }
    rr.join(' ')
  end

  def apply_position(ll_code)
    movements = {}

    4.times do |i|
      c_data = LL.corner_data(ll_code[i*2])
      movements[LL::U_CORNERS[i]] = c_to_here = @pieces[c_data.position(i).to_sym]
      c_to_here.shift(Move::D.shift, c_data.distance)
      c_to_here.rotate(c_data.spin)

      e_data = LL.edge_data(ll_code[2*i + 1])
      movements[LL::U_EDGES[i]] = e_to_here = @pieces[e_data.position(i).to_sym]
      e_to_here.shift(Move::D.shift, e_data.distance)
      e_to_here.rotate(e_data.spin)
    end

    movements.each { |position, piece| @pieces[position.to_sym] = piece }
    self
  end

  def apply_reverse_alg(moves)
    moves.split(' ').reverse.each do |move|
      unmove(move[0], Move.turns(move))
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

    outline = (on_side != 'U') ? ' outline' : ''
    "#{side}-color" + outline
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

  def unmove(side, turns)
    move(side, 4 - turns)
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
    not @pieces.values.detect { |piece| !piece.name.include?('U') && !piece.is_solved }
  end

  def solved()
    not @pieces.values.detect { |piece| !piece.is_solved }
  end

  def print
    @pieces.each { |pos, piece| puts "At #{pos}: #{piece.to_s}" }
  end
end
