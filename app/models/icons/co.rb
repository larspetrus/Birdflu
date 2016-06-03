# frozen_string_literal: true

class Icons::Co < Icons::Base

  def initialize(code, stickers)
    super(:co, code)

    pieces = %w(ULB_ UBR_ UFL_ URF_)
    stickers.each_with_index do |sticker, i|
      @colors[(pieces[i] + sticker).to_sym] = 'co'
    end
  end

  def base_colors
    @colors = { U: 'co'}
    set_colors('ignore', :UB_U, :UL_U, :UR_U, :UF_U)
  end

  def self.by_code(code)
    code ||= ''
    ALL.find { |op| op.code == code.to_sym }
  end

  def self.for(position)
    by_code(position.co)
  end

  def self.grid
    @@grid ||=
        [
            %w(A B b C D E F G)
        ].map{|row| row.map{|id| self.by_code(id)}}
  end

  ALL = [
      self.new(:'', []),
      self.new(:A, %w(U U U U)),
      self.new(:B, %w(U R L F)),
      self.new(:C, %w(U U L R)),
      self.new(:D, %w(U U F F)),
      self.new(:E, %w(U B L U)),
      self.new(:F, %w(L R L R)),
      self.new(:G, %w(L B L F)),
      self.new(:b, %w(U B F R)),
  ]
end


