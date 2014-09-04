class LlComboAlg

  def initialize(alg1, alg2)
    @alg1 = alg1
    @alg2 = alg2
    @combo = LlAlg.new("#{@alg1.name}+#{@alg2.name}", "#{@alg1.moves} #{@alg2.moves}")
  end

  def ll_code_by_moves()
    @combo.solves_ll_code
  end

  def name
    @combo.name
  end

  def length
    @combo.length
  end

  def moves
    @combo.moves
  end

  def nl
    @combo.nl
  end
end