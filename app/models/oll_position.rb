class OllPosition
  attr_reader :code, :name

  def initialize(code, name, stickers)
    @code = code
    @name = name

    pieces = %w(ULB_ UB_ UBR_ UL_ UR_ UFL_ UF_ URF_)
    @colors = { }
    stickers.each_with_index do |sticker, i|
      @colors[(pieces[i] + sticker).to_sym] = 'oll-color'
    end
  end

  def color(sticker_code)
    @colors[sticker_code]
  end

  def highlight(active_oll)
    return 'selected' if active_oll.to_sym == @code
  end

  ALL = [
    self.new(:m0,  'PLL',    %w(U U U U U U U U)),
    self.new(:m1,  'OLL 1',  %w(L B R L R L F R)),
    self.new(:m2,  'OLL 2',  %w(L B B L R L F F)),
    self.new(:m3,  'OLL 3',  %w(B B U L R L F F)),
    self.new(:m4,  'OLL 4',  %w(L B U L R F F R)),
    self.new(:m27, 'OLL 27', %w(B U R U U U U F)),
    self.new(:m26, 'OLL 26', %w(L U B U U F U U)),
    self.new(:m21, 'OLL 21', %w(L U R U U L U R)),
    self.new(:m22, 'OLL 22', %w(L U B U U L U F)),
    self.new(:m23, 'OLL 23', %w(B U B U U U U U)),
    self.new(:m24, 'OLL 24', %w(B U U U U F U U)),
    self.new(:m25, 'OLL 25', %w(U U B U U L U U)),
    self.new(:m17, 'OLL 17', %w(U B B L R L F U)),
    self.new(:m18, 'OLL 18', %w(L B U L R L F U)),
    self.new(:m19, 'OLL 19', %w(U B U L R L F R)),
    self.new(:m31, 'OLL 31', %w(U B B U R U U F)),
    self.new(:m32, 'OLL 32', %w(B B U L U F U U)),
    self.new(:m43, 'OLL 43', %w(U B R U R U U R)),
    self.new(:m44, 'OLL 44', %w(L B U L U L U U)),
    self.new(:m36, 'OLL 36', %w(U B R U R F U U)),
    self.new(:m38, 'OLL 38', %w(L B U L U U U F)),
    self.new(:m48, 'OLL 48', %w(L U B U R L F F)),
    self.new(:m47, 'OLL 47', %w(B U R L U F F R)),
    self.new(:m53, 'OLL 53', %w(L U R U R L F R)),
    self.new(:m54, 'OLL 54', %w(L U R L U L F R)),
    self.new(:m49, 'OLL 49', %w(B B R U R F U R)),
    self.new(:m50, 'OLL 50', %w(L B B L U L U F)),
    self.new(:m34, 'OLL 34', %w(L B R U U U F U)),
    self.new(:m46, 'OLL 46', %w(U U R L R U U R)),
    self.new(:m33, 'OLL 33', %w(B B U U U F F U)),
    self.new(:m45, 'OLL 45', %w(L B U U U L F U)),
    self.new(:m55, 'OLL 55', %w(L U R L R L U R)),
    self.new(:m56, 'OLL 56', %w(L B R U U L F R)),
    self.new(:m51, 'OLL 51', %w(B B R U U F F R)),
    self.new(:m52, 'OLL 52', %w(B U R L R F U R)),
    self.new(:m5,  'OLL 5',  %w(B B R L U L U U)),
    self.new(:m6,  'OLL 6',  %w(L B B U R U U R)),
    self.new(:m39, 'OLL 39', %w(B B U U U U F R)),
    self.new(:m40, 'OLL 40', %w(U B B U U F F U)),
    self.new(:m7,  'OLL 7',  %w(B U R U R U F F)),
    self.new(:m8,  'OLL 8',  %w(L U B L U F F U)),
    self.new(:m11, 'OLL 11', %w(B B R L U U U F)),
    self.new(:m12, 'OLL 12', %w(L B U L U F U L)),
    self.new(:m9,  'OLL 9',  %w(L U B L U U F R)),
    self.new(:m10, 'OLL 10', %w(B U R U R L F U)),
    self.new(:m35, 'OLL 35', %w(U B R L U F U U)),
    self.new(:m37, 'OLL 37', %w(B B U U R U U R)),
    self.new(:m13, 'OLL 13', %w(B B R U U U F F)),
    self.new(:m14, 'OLL 14', %w(L B B U U F F U)),
    self.new(:m15, 'OLL 15', %w(B B R U U L F U)),
    self.new(:m16, 'OLL 16', %w(L B B U U U F R)),
    self.new(:m29, 'OLL 29', %w(U B U U R L U R)),
    self.new(:m30, 'OLL 30', %w(U B U L U L U R)),
    self.new(:m41, 'OLL 41', %w(U B U L U F U F)),
    self.new(:m42, 'OLL 42', %w(U B U U R F U F)),
    self.new(:m28, 'OLL 28', %w(U U U U R U F U)),
    self.new(:m57, 'OLL 57', %w(U B U U U U F U)),
    self.new(:m20, 'OLL 20', %w(U B U L R U F U)),
]
end


