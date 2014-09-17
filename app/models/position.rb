class Position < ActiveRecord::Base
  has_many :ll_algs, -> { order "length" }
  belongs_to :best_alg, class_name: 'LlAlg'

  validates :ll_code, uniqueness: true

  before_create do
    self.oriented_edges = ll_code.count '1357'
    self.oriented_corners = ll_code.count 'aeio'
  end


  def tweaks()
    result = []
    4.times do |i|
      c_data = LL.corner_data(ll_code[i*2])
      corner_colors = c_data.position(i).chars.rotate(-c_data.spin).join

      e_data = LL.edge_data(ll_code[i*2 + 1])
      edge_colors = e_data.position(i).chars.rotate(e_data.spin).join

      result << "#{corner_colors}:#{LL.corners[i]}" << "#{edge_colors}:#{LL.edges[i]}"
    end
    result.join(' ')
  end

  def as_cube
    @cube ||= Cube.new.apply_position(ll_code)
  end
end
