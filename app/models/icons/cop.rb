# frozen_string_literal: true

class Icons::Cop < Icons::Base

  def initialize(code, stickers, *arrows)
    super(:cop, code)
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
        [:Ao,:Bo,:bo,:Co,:Do,:Eo,:Fo,:Go],
        [:Ad,:Bd,:bd,:Cd,:Dd,:Ed,:Fd,:Gd],
        [:Ab,:Bb,:bb,:Cb,:Db,:Eb,:Fb,:Gb],
        [:Al,:Bl,:bl,:Cl,:Dl,:El,:Fl,:Gl],
        [:Ar,:Br,:br,:Cr,:Dr,:Er,:Fr,:Gr],
        [:Af,:Bf,:bf,:Cf,:Df,:Ef,:Ff,:Gf],
      ].map{|row| row.map{|id| self.by_code(id)}}
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
    self.new(:Ab, CA, :B),
    self.new(:Al, CA, :L),
    self.new(:Ar, CA, :R),
    self.new(:Af, CA, :F),

    self.new(:Bo, CB),
    self.new(:Bd, CB, :D),
    self.new(:Bb, CB, :B),
    self.new(:Bl, CB, :L),
    self.new(:Br, CB, :R),
    self.new(:Bf, CB, :F),

    self.new(:Co, CC),
    self.new(:Cd, CC, :D),
    self.new(:Cb, CC, :B),
    self.new(:Cl, CC, :L),
    self.new(:Cr, CC, :R),
    self.new(:Cf, CC, :F),

    self.new(:Do, CD),
    self.new(:Dd, CD, :D),
    self.new(:Db, CD, :B),
    self.new(:Dl, CD, :L),
    self.new(:Dr, CD, :R),
    self.new(:Df, CD, :F),

    self.new(:Eo, CE),
    self.new(:Ed, CE, :D),
    self.new(:Eb, CE, :B),
    self.new(:El, CE, :L),
    self.new(:Er, CE, :R),
    self.new(:Ef, CE, :F),

    self.new(:Fo, CF),
    self.new(:Fd, CF, :D),
    self.new(:Fb, CF, :B),
    self.new(:Fl, CF, :L),
    self.new(:Fr, CF, :R),
    self.new(:Ff, CF, :F),

    self.new(:Go, CG),
    self.new(:Gd, CG, :D),
    self.new(:Gb, CG, :B),
    self.new(:Gl, CG, :L),
    self.new(:Gr, CG, :R),
    self.new(:Gf, CG, :F),

    self.new(:bo, Cb),
    self.new(:bd, Cb, :D),
    self.new(:bb, Cb, :B),
    self.new(:bl, Cb, :L),
    self.new(:br, Cb, :R),
    self.new(:bf, Cb, :F),

  ]
end


