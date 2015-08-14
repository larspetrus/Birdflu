class Icons::Cop < Icons::Base

  def initialize(code, stickers, *arrows)
    super(:cop, code)
    @name = (@is_none ? 'NONE' : code.to_s)
    @arrows = arrows

    pieces = %w(ULB_ UBR_ UFL_ URF_)
    stickers.each_with_index do |sticker, i|
      @colors[(pieces[i] + sticker).to_sym] = 'cop'
    end
  end

  def base_colors
    @colors = { U: 'cop'}
    set_colors('ignore', :UB_U, :UL_U, :UR_U, :UF_U)
  end

  def self.by_code(code)
    code ||= ''
    ALL.find { |op| op.code == code.to_sym }
  end

  def self.for(position)
    by_code(position.cop)
  end

  def self.grid
    @@grid ||=
      [
        [:'',:Ao,:Bo,:bo,:Co,:Do,:Eo,:Fo,:Go ].map{|id| self.by_code(id)},
        [:-, :Ad,:Bd,:bd,:Cd,:Dd,:Ed,:Fd,:Gd].map{|id| self.by_code(id)},
        [:- ,:Af,:Bf,:bf,:Cf,:Df,:Ef,:Ff,:Gf].map{|id| self.by_code(id)},
        [:- ,:- ,:Bb,:bb,:Cb,:Db,:Eb,:- ,:Gb].map{|id| self.by_code(id)},
        [:- ,:- ,:Bl,:bl,:Cl,:Dl,:El,:Fl,:Gl].map{|id| self.by_code(id)},
        [:- ,:- ,:Br,:br,:Cr,:Dr,:Er,:- ,:Gr].map{|id| self.by_code(id)},
      ]
  end

  CA = %w(U U U U)
  CB = %w(U R L F)
  Cb = %w(U B F R)
  CC = %w(U U L R)
  CD = %w(U U F F)
  CE = %w(U B L U)
  CF = %w(L R L R)
  CG = %w(L B L F)
  ALL = [
    self.new(:'', []),
    self.new(:Ao, CA),
    self.new(:Ad, CA, :D),
    self.new(:Af, CA, :F),
    self.new(:Bo, CB),
    self.new(:Bd, CB, :D),
    self.new(:Bl, CB, :L),
    self.new(:Bb, CB, :B),
    self.new(:Br, CB, :R),
    self.new(:Bf, CB, :F),
    self.new(:Co, CC),
    self.new(:Cd, CC, :D),
    self.new(:Cl, CC, :L),
    self.new(:Cf, CC, :F),
    self.new(:Cb, CC, :B),
    self.new(:Do, CD),
    self.new(:Dd, CD, :D),
    self.new(:Dl, CD, :L),
    self.new(:Df, CD, :F),
    self.new(:Db, CD, :B),
    self.new(:Eo, CE),
    self.new(:Ed, CE, :D),
    self.new(:Er, CE, :R),
    self.new(:El, CE, :L),
    self.new(:Fo, CF),
    self.new(:Fd, CF, :D),
    self.new(:Ff, CF, :F),
    self.new(:Fl, CF, :L),
    self.new(:Go, CG),
    self.new(:Gd, CG, :D),
    self.new(:Gb, CG, :B),
    self.new(:Gl, CG, :L),
    self.new(:Gr, CG, :R),
    self.new(:bo, Cb),
    self.new(:bd, Cb, :D),
    self.new(:bb, Cb, :B),
    self.new(:bl, Cb, :L),
    self.new(:bf, Cb, :F),
    self.new(:br, Cb, :R),
    self.new(:Cr, CC, :R),
    self.new(:Dr, CD, :R),
    self.new(:Ef, CE, :F),
    self.new(:Eb, CE, :B),
    self.new(:Gf, CG, :F),
  ]
end


