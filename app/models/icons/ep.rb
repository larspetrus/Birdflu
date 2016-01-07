class Icons::Ep < Icons::Base

  EP_CODES = Position::EP_NAMES.invert

  def initialize(name)
    super(:ep, name.to_sym)

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
    set_colors('ignore', :U, :UBR_U, :UFL_U, :URF_U)
    set_colors('ep-fixed', :ULB_U)
  end

  def self.by_code(code)
    code ||= ''
    ALL.find { |op| op.code == code.to_sym }
  end

  def self.for(position)
    by_code(position.ep)
  end

  def self.grid_for(cp)
    case PosSubsets.ep_type_by_cp(cp)
      when :upper
        @upper_icons ||= [self.upper_codes].map{|row| row.map{|id| self.by_code(id)}}
      when :lower
        @lower_icons ||= [self.lower_codes].map{|row| row.map{|id| self.by_code(id)}}
      when :both
        @both_icons ||= [self.upper_codes, self.lower_codes].map{|row| row.map{|id| self.by_code(id)}}
      else
        raise "Impossible EP type '#{PosSubsets.ep_type_by_cp(cp)}'!"
    end
  end

  def self.upper_codes
    @upper_codes ||= %w(A B C D E F G H I J K L)
  end

  def self.lower_codes
    @lower_codes ||= %w(a b c d e f g h i j k l)
  end

  ALL = [self.new(:'')] + (self.upper_codes + self.lower_codes).map{|code| self.new(code)}
end
