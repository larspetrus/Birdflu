class LlCode
  attr_reader :code

  def initialize(code)
    @code = code
  end
  def self.official_sort(ll_code)
    corner_orientations = [0,2,4,6].map { |i| co(ll_code[i]) }.join('')
    corner_positions = ll_code[0]+ll_code[2]+ll_code[4]+ll_code[6]
    edge_orientations   = [1,3,5,7].map { |i| eo(ll_code[i]) }.join('')
    edges = ll_code[1]+ll_code[3]+ll_code[5]+ll_code[7]

    corner_orientations + corner_positions + edge_orientations + edges
  end

  def self.pick_official_code(ll_codes)
    ll_codes.sort_by{ |lc| LlCode.official_sort(lc) }.first
  end

  def variants
    cube().ll_codes
  end

  def mirror
    cube().standard_ll_code(:mirror)
  end

  def oll_code
    oll_codes = variants.map do |code|
      [0,2,4,6].map { |i| "#{LlCode.co(code[i])}#{LlCode.eo(code[i+1])}" }.join('')
    end
    oll_codes.sort.first.to_sym
  end

  def cop_code
    (code[0]+code[2]+code[4]+code[6]).to_sym
  end

  def eo_code
    LlCode.eo(code[1])+LlCode.eo(code[3])+LlCode.eo(code[5])+LlCode.eo(code[7])
  end

  def ep_code
    ep(code[1])+ep(code[3])+ep(code[5])+ep(code[7])
  end

  def self.co(corner_code)
    @orientation ||= {a: :a, e: :a, i: :a, o: :a, b: :b, f: :b, j: :b, p: :b, c: :c, g: :c, k: :c, q: :c}
    @orientation[corner_code.to_sym].to_s
  end

  def self.eo(edge_code)
    '1357'.include?(edge_code) ? '1' : '2'
  end

  def ep(edge_code)
    '-11335577'[edge_code.to_i]
  end

  def cube
    @cube ||= Cube.new(@code)
  end
end