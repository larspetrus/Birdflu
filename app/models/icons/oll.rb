class Icons::Oll < Icons::Base

  def initialize(code, name, stickers)
    super(:oll, code)
    @name = name

    pieces = %w(ULB_ UB_ UBR_ UL_ UR_ UFL_ UF_ URF_)
    stickers.each_with_index do |sticker, i|
      @colors[(pieces[i] + sticker).to_sym] = 'oll'
    end
  end

  def base_colors
    @colors = { U: 'oll' }
  end

  def self.by_code(code)
    code ||= ''
    ALL.find { |op| op.code == code.to_sym }
  end

  def self.for(position)
    by_code(position.oll)
  end

  def self.grid
    @@grid ||=
        [
            [:-, :-, :-, :-, :-, :m0].map{|id| self.by_code(id)},
            %i(m28 m57 m20 - m23 m24 m25 m27 m26 m22 m21).map{|id| self.by_code(id)},
            %i(m3 m4 m17 m19 m18 m2 m1).map{|id| self.by_code(id)},
            %i(m33 m45 - m44 m43 m32 m31 - m38 m36).map{|id| self.by_code(id)},
            %i(m54 m53 m50 m49 m48 m47 - m5 m6).map{|id| self.by_code(id)},
            %i(m39 m40 - m34 m46 - m7 m12 m8 m11).map{|id| self.by_code(id)},
            %i(m37 m35 m10 m9 - m51 m52 m56 m55).map{|id| self.by_code(id)},
            %i(m13 m16 m14 m15 - m41 m30 m42 m29).map{|id| self.by_code(id)},
        ]
  end

  ALL = [
    self.new(:'',  'NONE',   []),
    self.new(:m0,  'PLL',    %w(U U U U U U U U)),
    self.new(:m1,  'OLL 1',  %w(L B R L R L F R)),
    self.new(:m2,  'OLL 2',  %w(L B B L R L F F)),
    self.new(:m3,  'OLL 3',  %w(U B R L R L F F)),
    self.new(:m4,  'OLL 4',  %w(U B B L R F F R)),
    self.new(:m27, 'OLL 27', %w(U U R U U L U F)),
    self.new(:m26, 'OLL 26', %w(U U B U U F U R)),
    self.new(:m21, 'OLL 21', %w(L U R U U L U R)),
    self.new(:m22, 'OLL 22', %w(L U B U U L U F)),
    self.new(:m23, 'OLL 23', %w(U U U U U F U F)),
    self.new(:m24, 'OLL 24', %w(U U U U U L U R)),
    self.new(:m25, 'OLL 25', %w(U U B U U L U U)),
    self.new(:m17, 'OLL 17', %w(U B B L R L F U)),
    self.new(:m18, 'OLL 18', %w(U B U L R F F F)),
    self.new(:m19, 'OLL 19', %w(U B U L R L F R)),
    self.new(:m31, 'OLL 31', %w(U U U U R L F R)),
    self.new(:m32, 'OLL 32', %w(U U U L U L F R)),
    self.new(:m43, 'OLL 43', %w(U U U U R F F F)),
    self.new(:m44, 'OLL 44', %w(U U U L U F F F)),
    self.new(:m36, 'OLL 36', %w(U U B L U L F U)),
    self.new(:m38, 'OLL 38', %w(B U U U R U F R)),
    self.new(:m48, 'OLL 48', %w(L U B U R L F F)),
    self.new(:m47, 'OLL 47', %w(L B B U R L U F)),
    self.new(:m53, 'OLL 53', %w(L U R U R L F R)),
    self.new(:m54, 'OLL 54', %w(L U R L U L F R)),
    self.new(:m49, 'OLL 49', %w(L U B L U L F F)),
    self.new(:m50, 'OLL 50', %w(L B B L U L U F)),
    self.new(:m34, 'OLL 34', %w(U B U U U L F R)),
    self.new(:m46, 'OLL 46', %w(U B U U U F F F)),
    self.new(:m33, 'OLL 33', %w(U U U L R L U R)),
    self.new(:m45, 'OLL 45', %w(U U U L R F U F)),
    self.new(:m55, 'OLL 55', %w(L U R L R L U R)),
    self.new(:m56, 'OLL 56', %w(L B R U U L F R)),
    self.new(:m51, 'OLL 51', %w(L B B U U L F F)),
    self.new(:m52, 'OLL 52', %w(L U B L R L U F)),
    self.new(:m5,  'OLL 5',  %w(U U R U R L F F)),
    self.new(:m6,  'OLL 6',  %w(U U B U R F F R)),
    self.new(:m39, 'OLL 39', %w(U U B L R L U U)),
    self.new(:m40, 'OLL 40', %w(U B B U U L F U)),
    self.new(:m7,  'OLL 7',  %w(U U R L U L F F)),
    self.new(:m8,  'OLL 8',  %w(U B B U R F U R)),
    self.new(:m11, 'OLL 11', %w(U B R U R L U F)),
    self.new(:m12, 'OLL 12', %w(U U B L U F F R)),
    self.new(:m9,  'OLL 9',  %w(U B B L U F U R)),
    self.new(:m10, 'OLL 10', %w(U B R L U L U F)),
    self.new(:m35, 'OLL 35', %w(U U B U R L F U)),
    self.new(:m37, 'OLL 37', %w(U B B L U L U U)),
    self.new(:m13, 'OLL 13', %w(U U R L R L U F)),
    self.new(:m14, 'OLL 14', %w(U B B U U F F R)),
    self.new(:m15, 'OLL 15', %w(U B R U U L F F)),
    self.new(:m16, 'OLL 16', %w(U U B L R F U R)),
    self.new(:m29, 'OLL 29', %w(U B U U R L U R)),
    self.new(:m30, 'OLL 30', %w(U B U L U L U R)),
    self.new(:m41, 'OLL 41', %w(U B U L U F U F)),
    self.new(:m42, 'OLL 42', %w(U B U U R F U F)),
    self.new(:m28, 'OLL 28', %w(U U U U R U F U)),
    self.new(:m57, 'OLL 57', %w(U B U U U U F U)),
    self.new(:m20, 'OLL 20', %w(U B U L R U F U)),
]
end


