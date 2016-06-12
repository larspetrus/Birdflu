# frozen_string_literal: true

class DbAlg
  def initialize(alg)
    @alg = (alg || '').freeze
  end

  def +(alg)
    DbAlg.new(@alg + alg.to_s)
  end

  def [](*args)
    DbAlg.new(@alg[*args])
  end

  def move_count
    @alg.length
  end

  def ui_alg
    UiAlg.new(Algs.unpack(@alg))
  end

  def to_s
    @alg
  end
end