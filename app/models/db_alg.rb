# frozen_string_literal: true

class DbAlg
  def initialize(alg)
    @alg = (alg || '').freeze
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