class Icons::Ep < Icons::Base

  EP_CODES = Position::EP_NAMES.invert

  def initialize(name)
    super(:ep, name.to_sym)

    @name = (@is_none ? 'NONE' : name.to_s)
    @arrows = []

    edges = [:UB_U, :UR_U, :UF_U, :UL_U]
    edge_sides = edges.map{|edge| edge[1]}
    edge_movements = {}

    code = EP_CODES[name] || ''
    code.length.times do |i|
      offset = '1357'.index(code[i])
      @colors[edges[i]] = "ep-across" if offset == 2

      from, to = edge_sides[i], edge_sides[(i + offset) % 4]
      if edge_movements[to] == from # we have both directions, make a double arrow
        edge_movements.delete(to)
        @arrows << [from, to].sort.join('d').to_sym
      else
        edge_movements[from] = to
      end
    end
    edge_movements.each { |from, to| @arrows << "#{from}2#{to}".to_sym if from != to }
  end

  def base_colors
    set_colors('ignore', :U, :ULB_U, :UBR_U, :UFL_U, :URF_U)
  end

  def self.by_code(code)
    code ||= ''
    ALL.find { |op| op.code == code.to_sym }
  end

  def self.for(position)
    by_code(position.ep)
  end

  def self.grid_for(cop)
    PosSubsets.ep_code_grid_by_cop(cop).map{|row| row.map{|id| self.by_code(id)}}
  end

  ALL = [
      self.new(:''),
      self.new('A'),
      self.new('E'),
      self.new('K'),
      self.new('I'),
      self.new('F'),
      self.new('H'),
      self.new('G'),
      self.new('L'),
      self.new('J'),
      self.new('B'),
      self.new('D'),
      self.new('C'),
      self.new('a'),
      self.new('k'),
      self.new('i'),
      self.new('l'),
      self.new('j'),
      self.new('d'),
      self.new('e'),
      self.new('b'),
      self.new('f'),
      self.new('g'),
      self.new('c'),
      self.new('h'),
  ]
end
