class EpIcons < LlIcons

  def initialize(code, stickers, *arrows)
    super(:ep, code.to_sym)
    @name = (@is_none ? 'NONE' : 'P' + code)
    @arrows = arrows

    code.length.times do |i|
      offset = '1357'.index(code[i])
      sc = %w(b r f l)[(i + offset) % 4] if offset != 0
      sticker = [:UB_U, :UR_U, :UF_U, :UL_U][i]
      @colors[sticker] = "ep-#{sc}-color"
    end
  end

  def base_colors
    set_colors('ep-b-color', :ULB_B, :UB_B, :UBR_B)
    set_colors('ep-l-color', :ULB_L, :UL_L, :UFL_L)
    set_colors('ep-f-color', :UFL_F, :UF_F, :URF_F)
    set_colors('ep-r-color', :UBR_R, :UR_R, :URF_R)
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
      self.new(:'', []),
      self.new('1111', %w(U U U U)),
      self.new('1335', %w(U U U U)),
      self.new('3351', %w(U U U U)),
      self.new('3513', %w(U U U U)),
      self.new('1577', %w(U U U U)),
      self.new('7157', %w(U U U U)),
      self.new('5133', %w(U U U U)),
      self.new('5771', %w(U U U U)),
      self.new('7715', %w(U U U U)),
      self.new('5555', %w(U U U U), :M, :S),
      self.new('3737', %w(U U U U)),
      self.new('7373', %w(U U U U)),
      self.new('7777', %w(U U U U)),
      self.new('7113', %w(U U U U)),
      self.new('1137', %w(U U U U)),
      self.new('7355', %w(U U U U)),
      self.new('3557', %w(U U U U)),
      self.new('5151', %w(U U U U), :M),
      self.new('3711', %w(U U U U)),
      self.new('3333', %w(U U U U)),
      self.new('5735', %w(U U U U)),
      self.new('1371', %w(U U U U)),
      self.new('1515', %w(U U U U), :S),
      self.new('5573', %w(U U U U)),
  ]
end
