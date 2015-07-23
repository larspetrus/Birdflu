class EoState
  attr_reader :code, :name

  def initialize(code, stickers)
    is_none = code == :''
    @code = code
    @name = (is_none ? 'NONE' : 'O' + code)

    @colors = is_none ? {} : { U: 'eo-color', ULB_U: 'ignored-color', UBR_U: 'ignored-color', UFL_U: 'ignored-color', URF_U: 'ignored-color'}
    pieces = %w(UB_ UR_ UF_ UL_)
    stickers.each_with_index do |sticker, i|
      @colors[(pieces[i] + sticker).to_sym] = 'eo-color'
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
    '#eo'
  end

  def self.by_code(code)
    ALL.find { |op| op.code == code }
  end

  ALL = [
      self.new(:'', []),
      self.new('1111', %w(U U U U)),
      self.new('1122', %w(U U F L)),
      self.new('1212', %w(U R U L)),
      self.new('1221', %w(U R F U)),
      self.new('2112', %w(B U U L)),
      self.new('2121', %w(B U F U)),
      self.new('2211', %w(B R U U)),
      self.new('2222', %w(B R F L)),
  ]
end
