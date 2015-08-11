class Icons::Eo < Icons::Base

  def initialize(code, stickers)
    super(:eo, code.to_sym)

    @name = (@is_none ? 'NONE' : Icons::Eo.name_for_code(code))

    pieces = %w(UB_ UR_ UF_ UL_)
    stickers.each_with_index do |sticker, i|
      @colors[(pieces[i] + sticker).to_sym] = 'eo'
    end
  end

  def base_colors
    @colors = { U: 'eo'}
    set_colors('ignore', :ULB_U, :UBR_U, :UFL_U, :URF_U)
  end

  def self.name_for_code(code)
    {'1111'=>'4','1122'=>'6','1212'=>'1','1221'=>'9','2112'=>'7','2121'=>'2','2211'=>'8','2222'=>'0'}[code]
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
            [:'', '2222', '1212', '2121', '1111', '1122', '2112', '2211', '1221'].map{|id| self.by_code(id)},
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
