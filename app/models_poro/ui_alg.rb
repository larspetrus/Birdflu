# frozen_string_literal: true

# Handles alg strings in human readable format (Sune = "F U F' U F U2 F'"). Counterpart to DbAlg.
class UiAlg
  def initialize(alg)
    @alg = (alg || '').freeze
  end

  def +(alg)
    UiAlg.new(@alg + ' ' + alg.to_s)
  end

  def move_count
    @alg.split(' ').length
  end


  def db_alg
    DbAlg.new(Algs.pack(@alg))
  end

  def to_s
    @alg
  end
end