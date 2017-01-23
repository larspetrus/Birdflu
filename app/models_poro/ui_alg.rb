# frozen_string_literal: true

# Handles alg strings in human readable format (Sune = "F U F' U F U2 F'"). Counterpart to DbAlg. Immutable.
class UiAlg
  def initialize(alg)
    @alg = (alg || '').freeze
  end

  def +(alg)
    UiAlg.new(@alg + ' ' + alg.to_s)
  end

  def move_count
    to_a.length
  end

  def shift(turns = 1)
    UiAlg.new(Algs.shift(@alg, turns))
  end


  def db_alg
    DbAlg.new(Algs.pack(@alg))
  end

  def to_a
    @array ||= @alg.split(' ')
  end

  def to_s
    @alg
  end
end