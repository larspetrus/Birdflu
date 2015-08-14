class Icons::Ep < Icons::Base

  def initialize(code)
    super(:ep, code.to_sym)

    @name = (@is_none ? 'NONE' : Icons::Ep.name_for_code(code))
    @arrows = []

    edges = [:UB_U, :UR_U, :UF_U, :UL_U]
    edge_sides = edges.map{|edge| edge[1]}
    edge_movements = {}
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

  def self.name_for_code(code)
    {'1111'=>'A', '5555'=>'B', '7373'=>'C', '3737'=>'D', '1335'=>'E', '1577'=>'F',
     '5133'=>'G', '7157'=>'H', '3513'=>'I', '7715'=>'J', '3351'=>'K', '5771'=>'L',
     '7777'=>'a', '3333'=>'b', '1515'=>'c', '5151'=>'d', '3711'=>'e', '5735'=>'f',
     '1371'=>'g', '5573'=>'h', '1137'=>'i', '3557'=>'j', '7113'=>'k', '7355'=>'l'}[code]
  end

  def self.by_code(code)
    code ||= ''
    ALL.find { |op| op.code == code.to_sym }
  end

  def self.for(position)
    by_code(position.ep)
  end

  def self.grid
    @@grid ||=
        [
            [:''].map{|id| self.by_code(id)},
            %w(1111 5555 7373 3737 1335 1577 5133 7157 3513 7715 3351 5771).map{|id| self.by_code(id)},
            %w(7777 3333 1515 5151 3711 5735 1371 5573 1137 3557 7113 7355).map{|id| self.by_code(id)},
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
