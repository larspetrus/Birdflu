# frozen_string_literal: true

class Cube
  def self.by_alg(alg)
    Cube.new.apply_reverse_alg(alg)
  end

  def self.by_code(ll_code)
    Cube.new.apply_position(ll_code)
  end

  def initialize(state = nil)
    @pieces = { }
    Piece::NAMES.each { |piece| @pieces[piece] = Piece.new(piece) }
  end

  def state_string
    Piece::NAMES.map {|piece| piece_at(piece).state_code_at(piece) }.join('')
  end

  def f2l_state_string
    Piece::NAMES.map {|piece| piece_at(piece).f2l_state_code_at(piece) }.join('')
  end

  def apply_position(ll_code)
    displacements = {}

    4.times do |i|
      corner_data = LL.corner_data(ll_code[i*2])
      displacements[LL::U_CORNERS[i]] = corner_belonging_here = @pieces[corner_data.position(i).to_sym]
      corner_belonging_here.shift(Piece.movement(:D), corner_data.distance)
      corner_belonging_here.rotate(corner_data.spin)

      edge_data = LL.edge_data(ll_code[2*i + 1])
      displacements[LL::U_EDGES[i]] = edge_belonging_here = @pieces[edge_data.position(i).to_sym]
      edge_belonging_here.shift(Piece.movement(:D), edge_data.distance)
      edge_belonging_here.rotate(edge_data.spin)
    end

    displacements.each { |position, piece| @pieces[position.to_sym] = piece }
    self
  end

  def apply_reverse_alg(moves)
    moves.split(' ').reverse.each { |move| undo(Move[move]) }
    self
  end

  def sticker_at(position, side)
    piece_at(position).sticker_on(side)
  end

  def color_at(position, side) # Same as RoofPig
    {R: '#0d0', L: '#07f', F: 'red', B: 'orange', U: 'yellow', D: '#eee'}[piece_at(position).sticker_on(side).to_sym]
  end

  def color_css(position, on_side)
    side = on_side ? piece_at(position).sticker_on(on_side).to_s : position
    "#{side.downcase}-color"
  end

  def piece_at(position)
    @pieces[position.to_sym]
  end

  def do(move)
    movement = Piece.movement(move.side)
      movement.cycles.each do |cyc|
        cyc.each { |position| @pieces[position].shift(movement, move.turns) }
        move.turns.times { @pieces[cyc[0]],@pieces[cyc[1]],@pieces[cyc[2]],@pieces[cyc[3]] = @pieces[cyc[1]],@pieces[cyc[2]],@pieces[cyc[3]],@pieces[cyc[0]] }
    end
  end

  def undo(move)
    self.do(move.inverse)
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
    raise "Alg does not solve F2L" unless f2l_solved()

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
