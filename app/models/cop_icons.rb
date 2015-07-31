class CopIcons < LlIcons

  def initialize(code, stickers, *arrows)
    super(:cl, code)
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

  def self.grid
    @@grid ||=
      [
        [:'',:A, :B, :b, :C, :D, :E, :F, :G ].map{|id| self.by_code(id)},
        [:-, :AA,:BB,:bb,:CC,:DD,:EE,:FF,:GG].map{|id| self.by_code(id)},
        [:- ,:Ax,:Bx,:bx,:Cx,:Dx,:Ex,:Fx,:Gx].map{|id| self.by_code(id)},
        [:- ,:- ,:By,:by,:Cy,:Dy,:Ey,:Fy,:Gy].map{|id| self.by_code(id)},
        [:- ,:- ,:Bz,:bz,:Cz,:Dz,:ex,:- ,:Gz].map{|id| self.by_code(id)},
        [:- ,:- ,:Bq,:bq,:cx,:dx,:ey,:- ,:gx].map{|id| self.by_code(id)},
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
    self.new(:A , CA),
    self.new(:AA, CA, :D),
    self.new(:Ax, CA, :F),
    self.new(:B , CB),
    self.new(:BB, CB, :D),
    self.new(:Bq, CB, :L),
    self.new(:Bx, CB, :B),
    self.new(:By, CB, :R),
    self.new(:Bz, CB, :F),
    self.new(:C , CC),
    self.new(:CC, CC, :D),
    self.new(:Cx, CC, :L),
    self.new(:Cy, CC, :F),
    self.new(:Cz, CC, :B),
    self.new(:D , CD),
    self.new(:DD, CD, :D),
    self.new(:Dx, CD, :L),
    self.new(:Dy, CD, :F),
    self.new(:Dz, CD, :B),
    self.new(:E , CE),
    self.new(:EE, CE, :D),
    self.new(:Ex, CE, :R),
    self.new(:Ey, CE, :L),
    self.new(:F , CF),
    self.new(:FF, CF, :D),
    self.new(:Fx, CF, :F),
    self.new(:Fy, CF, :L),
    self.new(:G , CG),
    self.new(:GG, CG, :D),
    self.new(:Gx, CG, :B),
    self.new(:Gy, CG, :L),
    self.new(:Gz, CG, :R),
    self.new(:b , Cb),
    self.new(:bb, Cb, :D),
    self.new(:bq, Cb, :B),
    self.new(:bx, Cb, :L),
    self.new(:by, Cb, :F),
    self.new(:bz, Cb, :R),
    self.new(:cx, CC, :R),
    self.new(:dx, CD, :R),
    self.new(:ex, CE, :F),
    self.new(:ey, CE, :B),
    self.new(:gx, CG, :F),
  ]
end


