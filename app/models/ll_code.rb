class LlCode
  attr_reader :code

  def initialize(code)
    @code = code
  end

  def self.standard_sort(ll_code)
    puts "----------- #{ll_code} -> #{co_code(ll_code)}"

    co_code(ll_code) + ll_code[0]+ll_code[2]+ll_code[4]+ll_code[6]+ll_code[1]+ll_code[3]+ll_code[5]+ll_code[7]
  end

  def self.co_code(x_code)
    no_p = {a: :a, e: :a, i: :a, o: :a, b: :b, f: :b, j: :b, p: :b, c: :c, g: :c, k: :c, q: :c}
    [0,2,4,6].map { |i| "#{no_p[x_code[i].to_sym]}" }.join('')
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
      [0,2,4,6].map { |i| "#{no_p[code[i].to_sym]}#{eo(code[i+1])}" }.join('')
    end
    oll_codes.sort.first.to_sym
  end

  def cop_code
    variants().map{|code| code[0]+code[2]+code[4]+code[6] }.sort.first.to_sym
  end

  #based on standard ll_code
  def eo_code
    (eo(code[1])+eo(code[3])+eo(code[5])+eo(code[7])).to_sym
  end

  def ep_code
    (ep(code[1])+ep(code[3])+ep(code[5])+ep(code[7])).to_sym
  end

  def eo(edge_code)
    '1357'.include?(edge_code) ? '1' : '2'
  end

  def ep(edge_code)
    '-11335577'[edge_code.to_i]
  end

  def cube
    @cube ||= Cube.new(@code)
  end
end