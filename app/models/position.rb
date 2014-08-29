Corn = Struct.new(:place, :spin, :next) do
end

CC = {
    a: Corn.new(0, 0, :e),
    b: Corn.new(0, 2, :f),
    c: Corn.new(0, 1, :g),
    e: Corn.new(1, 0, :i),
    f: Corn.new(1, 2, :j),
    g: Corn.new(1, 1, :k),
    i: Corn.new(2, 0, :o),
    j: Corn.new(2, 2, :p),
    k: Corn.new(2, 1, :q),
    o: Corn.new(3, 0, :a),
    p: Corn.new(3, 2, :b),
    q: Corn.new(3, 1, :c),
}

class Position < ActiveRecord::Base
  PLACE= { a:0, b:0, c:0, e:1, f:1, g:1, i:2, j:2, k:2, o:3, p:3, q:3}
  SPIN = { a:0, e:0, i:0, o:0, b:2, f:2, j:2, p:2, c:1, g:1, k:1, q:1}
  CORNERS = %w[ULB UBR URF UFL]
  EDGES   = %w[UB UR UF UL]

  def tweaks()
    result = []

    4.times do |i|
      corner_code = code[i*2].to_sym
      corner = CORNERS[(PLACE[corner_code] + i) % 4]
      corner_colors = corner.chars.rotate(SPIN[corner_code]).join

      edge_code = code[i*2 + 1].to_i
      edge = EDGES[((edge_code-1)/2 + i) % 4]
      edge_colors = edge_code.odd? ? edge : edge.reverse()

      result << "#{corner_colors}:#{CORNERS[i]}" << "#{edge_colors}:#{EDGES[i]}"
    end
    result.join(' ')
  end

  def aliases
    [code, 'blah', 'blah2', 'oops4']
  end
end
