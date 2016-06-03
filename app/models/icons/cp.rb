# frozen_string_literal: true

class Icons::Cp < Icons::Base

  def initialize(code, *arrows)
    super(:cp, code)
    @arrows = arrows
  end

  def base_colors
    set_colors('cp', :U, :ULB_U, :UBR_U, :UFL_U, :URF_U)
    set_colors('ignore', :UB_U, :UL_U, :UR_U, :UF_U)
  end

  def self.by_code(code)
    code ||= ''
    ALL.find { |op| op.code == code.to_sym }
  end

  def self.for(position)
    by_code(position.cp)
  end

  def self.grid
    @@grid ||=
        [
            %w(o d b l r f),
        ].map{|row| row.map{|id| self.by_code(id)}}
  end

  ALL = [
      self.new(:''),
      self.new(:o),
      self.new(:d, :D),
      self.new(:b, :B),
      self.new(:l, :L),
      self.new(:r, :R),
      self.new(:f, :F),
  ]
end


