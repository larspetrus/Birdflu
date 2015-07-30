class EpIcons < LlIcons

  def initialize(code)
    super(:ep, code.to_sym)
    @name = (@is_none ? 'NONE' : 'P' + code)
    @arrows = []

    edges = [:UB_U, :UR_U, :UF_U, :UL_U]
    edge_sides = edges.map{|edge| edge[1]}
    edge_shifts = {}
    code.length.times do |i|
      offset = '1357'.index(code[i])
      sc = ['', 1, 2, 1][offset]
      @colors[edges[i]] = "ep-#{sc}-color"

      from, to = edge_sides[i], edge_sides[(i + offset) % 4]
      if edge_shifts[to] == from
        edge_shifts.delete(to)
        @arrows << [from, to].sort.join('d').to_sym # double arrow
      else
        edge_shifts[from] = to
      end
    end
    edge_shifts.each { |from, to| @arrows << "#{from}2#{to}".to_sym if from != to }
  end

  def base_colors
    set_colors('ep-b-color', :ULB_B, :UBR_B)
    set_colors('ep-l-color', :ULB_L, :UFL_L)
    set_colors('ep-f-color', :UFL_F, :URF_F)
    set_colors('ep-r-color', :UBR_R, :URF_R)
    set_colors('ignored-color', :U, :ULB_U, :UBR_U, :UFL_U, :URF_U)
  end

  def self.by_code(code)
    code ||= ''
    ALL.find { |op| op.code == code.to_sym }
  end

  def self.grid
    @@grid ||=
        [
            [:''].map{|id| self.by_code(id)},
            %w(1111 5555 7373 3737 1335 3351 3513 1577 7157 5133 5771 7715).map{|id| self.by_code(id)},
            %w(7113 1137 3711 1371 7777 3333 5151 1515 7355 3557 5735 5573).map{|id| self.by_code(id)},
        ]
  end

  ALL = [
      self.new(:''),
      self.new('1111'),
      self.new('1335'),
      self.new('3351'),
      self.new('3513'),
      self.new('1577'),
      self.new('7157'),
      self.new('5133'),
      self.new('5771'),
      self.new('7715'),
      self.new('5555'),
      self.new('3737'),
      self.new('7373'),
      self.new('7777'),
      self.new('7113'),
      self.new('1137'),
      self.new('7355'),
      self.new('3557'),
      self.new('5151'),
      self.new('3711'),
      self.new('3333'),
      self.new('5735'),
      self.new('1371'),
      self.new('1515'),
      self.new('5573'),
  ]
end
