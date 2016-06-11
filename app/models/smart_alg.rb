class SmartAlg
  def initialize(alg)
    alg ||= ''
    if SmartAlg.notation(alg) == :standard
      @standard = alg
    else
      @packed = alg
    end
  end

  def standard
    @standard ||= Algs.unpack(@packed)
  end

  def packed
    @packed ||= Algs.pack(@standard)
  end

  def to_s
    standard
  end

  def self.notation(alg)
    if alg.include?(' ') || (alg.length == 2 && "2'".include?(alg[1]))
      :standard
    else
      :packed
    end
  end

end