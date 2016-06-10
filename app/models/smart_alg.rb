class SmartAlg
  def initialize(alg)
    alg ||= ''
    if SmartAlg.notation(alg) == :standard
      @standard = alg
    else
      @compressed = alg
    end
  end

  def standard
    @standard ||= Algs.expand(@compressed)
  end

  def compressed
    @compressed ||= Algs.compress(@standard)
  end

  def to_s
    standard
  end

  def self.notation(alg)
    if alg.include?(' ') || (alg.length == 2 && "2'".include?(alg[1]))
      :standard
    else
      :compressed
    end
  end

end