class LlCode
  attr_reader :code

  def initialize(code)
    @code = code
  end


def variants
    cube().ll_codes
  end

  def mirror
    cube().standard_ll_code(:mirror)
  end

  def standardize
    cube().standard_ll_code
  end

  def oll_code
    no_p = {a: :a, e: :a, i: :a, o: :a, b: :b, f: :b, j: :b, p: :b, c: :c, g: :c, k: :c, q: :c}
    oll_codes = variants.map do |code|
      [0,2,4,6].map { |i| "#{no_p[code[i].to_sym]}#{(2-code[i+1].to_i % 2)}" }.join('')
    end
    oll_codes.sort.first.to_sym
  end

  def cop_code
    variants().map{|code| code[0]+code[2]+code[4]+code[6] }.sort.first.to_sym
  end

  def eop_code
    variants().map{|code| code[1]+code[3]+code[5]+code[7] }.sort.first.to_sym
  end

  def cube
    @cube ||= Cube.new(@code)
  end
end