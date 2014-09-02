class LlComboAlg

  def initialize(alg1, alg2)
    @alg1 = alg1
    @alg2 = alg2
  end

  def ll_code_by_moves()
    c_alg = LlAlg.new("#{@alg1.name}+#{@alg2.name}", "#{@alg1.moves} #{@alg2.moves}")
    c_alg.solves_ll_code
  end

  def name
    "#{@alg1.name}+#{@alg2.name}"
  end
end