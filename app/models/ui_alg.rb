# frozen_string_literal: true

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