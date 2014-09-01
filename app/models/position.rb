class Position
  def initialize(ll_code)
    @ll_code = ll_code
  end

  def tweaks()
    result = []
    4.times do |i|
      c_data = LL.corner_data(@ll_code[i*2])
      corner_colors = c_data.position(i).chars.rotate(-c_data.spin).join

      e_data = LL.edge_data(@ll_code[i*2 + 1])
      edge_colors = e_data.position(i).chars.rotate(e_data.spin).join

      result << "#{corner_colors}:#{LL.corners[i]}" << "#{edge_colors}:#{LL.edges[i]}"
    end
    result.join(' ')
  end
end
