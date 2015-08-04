class EoIcons < LlIcons

  def initialize(code, stickers)
    super(:eo, code.to_sym)

    names = {'1111'=>'+','1122'=>'L','1212'=>'I','1221'=>'V','2112'=>'F','2121'=>'-','2211'=>'7','2222'=>'0'}
    @name = (@is_none ? 'NONE' : names[code])

    pieces = %w(UB_ UR_ UF_ UL_)
    stickers.each_with_index do |sticker, i|
      @colors[(pieces[i] + sticker).to_sym] = 'eo'
    end
  end

  def base_colors
    @colors = { U: 'eo'}
    set_colors('ignore', :ULB_U, :UBR_U, :UFL_U, :URF_U)
  end

  def self.by_code(code)
    code ||= ''
    ALL.find { |op| op.code == code.to_sym }
  end

  def self.for(position)
    by_code(position.edge_orientations)
  end

  def self.grid
    @@grid ||=
        [
            [:'', '1111', '1122', '1212', '1221', '2112', '2121', '2211', '2222'].map{|id| self.by_code(id)},
        ]
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
