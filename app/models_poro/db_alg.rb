# frozen_string_literal: true

# Handles alg strings in packed format (Sune = "FUEUFuE"). Counterpart to UiAlg. Immutable.
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

  def first(n)
    DbAlg.new(@alg.first(n))
  end

  def not_first(n)
    last(@alg.length - n)
  end

  def last(n)
    DbAlg.new(@alg.last(n))
  end

  def not_last(n)
    first(@alg.length - n)
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