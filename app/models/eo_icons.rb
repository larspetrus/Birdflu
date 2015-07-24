class EoIcons < LlIcons

  def initialize(code, stickers)
    super(:eo, code.to_sym)
    @name = (@is_none ? 'NONE' : 'O' + code)

    pieces = %w(UB_ UR_ UF_ UL_)
    stickers.each_with_index do |sticker, i|
      @colors[(pieces[i] + sticker).to_sym] = 'eo-color'
    end
  end

  def base_colors
    @colors = { U: 'eo-color'}
    set_colors('ignored-color', :ULB_U, :UBR_U, :UFL_U, :URF_U)
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
