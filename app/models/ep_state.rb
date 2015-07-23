class EpState
  attr_reader :code, :name

  def initialize(code, stickers)
    is_none = code == :''
    @code = code
    @name = (is_none ? 'NONE' : 'P' + code)

    @colors = is_none ? {} :
        { U: 'ignored-color',
          ULB_U: 'ignored-color', UBR_U: 'ignored-color', UFL_U: 'ignored-color', URF_U: 'ignored-color',
          ULB_B: 'ep-b-color', UB_B: 'ep-b-color', UBR_B: 'ep-b-color',
          ULB_L: 'ep-l-color', UL_L: 'ep-l-color', UFL_L: 'ep-l-color',
          UFL_F: 'ep-f-color', UF_F: 'ep-f-color', URF_F: 'ep-f-color',
          UBR_R: 'ep-r-color', UR_R: 'ep-r-color', URF_R: 'ep-r-color',
        }
    unless is_none
      0.upto(3).each do |i|
        code_char = code[i]
        offset = '1357'.index(code_char)
        sticker = [:UB_U, :UR_U, :UF_U, :UL_U][i]
        color = ['ep-b-color', 'ep-r-color', 'ep-f-color', 'ep-l-color'][(i + offset) % 4] if offset != 0

        @colors[sticker] = color
      end
    end
  end

  def color(sticker_code)
    @colors[sticker_code]
  end

  def highlight(selected_name)
    'selected' if (selected_name || '') == @code
  end

  def corner_swap
    # n/a
  end

  def field
    '#ep'
  end

  def self.by_code(code)
    ALL.find { |op| op.code == code }
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
      self.new('5555', %w(U U U U)),
      self.new('3737', %w(U U U U)),
      self.new('7373', %w(U U U U)),
      self.new('7777', %w(U U U U)),
      self.new('7113', %w(U U U U)),
      self.new('1137', %w(U U U U)),
      self.new('7355', %w(U U U U)),
      self.new('3557', %w(U U U U)),
      self.new('5151', %w(U U U U)),
      self.new('3711', %w(U U U U)),
      self.new('3333', %w(U U U U)),
      self.new('5735', %w(U U U U)),
      self.new('1371', %w(U U U U)),
      self.new('1515', %w(U U U U)),
      self.new('5573', %w(U U U U)),
  ]
end
