# frozen_string_literal: true

module LL
  U_CORNERS = %w[ULB UBR URF UFL]
  U_EDGES   = %w[UB UR UF UL]

  PieceCode = Struct.new(:name, :distance, :spin, :pieces) do
    def position(offset)
      pieces[(distance + offset) % 4]
    end
  end

  @@data = {}
  @@c_codes = []

  [[:a,0,0],[:b,0,1],[:c,0,2],[:e,1,0],[:f,1,1],[:g,1,2],[:i,2,0],[:j,2,1],[:k,2,2],[:o,3,0],[:p,3,1],[:q,3,2]].each do |cd|
    @@data[cd[0]] = PieceCode.new(cd[0], cd[1], cd[2], U_CORNERS)
    @@c_codes[3*cd[1] + cd[2]] = cd[0].to_s
  end
  [[1,0,0],[2,0,1],[3,1,0],[4,1,1],[5,2,0],[6,2,1],[7,3,0],[8,3,1]].each do |ed|
    @@data[ed[0]] = PieceCode.new(ed[0], ed[1], ed[2], U_EDGES)
  end

  def self.corner_data(code)
    @@data[code.to_sym]
  end

  def self.edge_data(code)
    @@data[code.to_i]
  end

  def self.corners
    U_CORNERS
  end

  def self.edges
    U_EDGES
  end

  def self.corner_code(distance, spin)
    @@c_codes[3*distance + spin]
  end

  def self.edge_code(distance, spin)
    (2*distance + spin + 1).to_s
  end
end