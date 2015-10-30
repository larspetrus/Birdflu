class Icons::Eo < Icons::Base

  def initialize(name, stickers)
    super(:eo, name.to_sym)

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
    by_code(position.eo)
  end

  def self.grid
    @@grid ||=
        [
            %w(0 1 2 4 6 7 8 9)
        ].map{|row| row.map{|id| self.by_code(id)}}
  end

  ALL = [
      self.new(:'', []),
      self.new('4', %w(U U U U)),
      self.new('6', %w(U U F L)),
      self.new('1', %w(U R U L)),
      self.new('9', %w(U R F U)),
      self.new('7', %w(B U U L)),
      self.new('2', %w(B U F U)),
      self.new('8', %w(B R U U)),
      self.new('0', %w(B R F L)),
  ]
end
