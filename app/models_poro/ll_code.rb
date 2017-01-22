# frozen_string_literal: true

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
    @cube ||= Cube.by_code(@code)
  end


  def self.filter_names(ll_code, target = {})
    ll_code_obj = LlCode.new(ll_code)

    cop_name = COP_NAMES[ll_code_obj.cop_code] || NON_STANDARD_COP
    target[:cop] = cop_name
    target[:co]  = cop_name[0]
    target[:cp]  = cop_name[1]

    target[:oll] = OLL_NAMES[ll_code_obj.oll_code]
    target[:eo]  = EO_NAMES[ll_code_obj.eo_code]
    target[:ep]  = EP_NAMES[ll_code_obj.ep_code]

    target
  end

  NON_STANDARD_COP = 'xx'

  COP_NAMES = {
      aiai: 'Ad',
      aaeo: 'Af',
      aaaa: 'Ao',
      ajpp: 'bb',
      ajbj: 'bd',
      abfp: 'bf',
      affj: 'bl',
      abbb: 'bo',
      afpb: 'br',
      akqq: 'Bb',
      akck: 'Bd',
      acgq: 'Bf',
      aggk: 'Bl',
      accc: 'Bo',
      agqc: 'Br',
      aibk: 'Cd',
      aafq: 'Cf',
      aabc: 'Co',
      aepc: 'Cr',
      aicj: 'Dd',
      aagp: 'Df',
      aacb: 'Do',
      aeqb: 'Dr',
      ajak: 'Ed',
      abeq: 'Ef',
      afek: 'El',
      abac: 'Eo',
      afoc: 'Er',
      bkbk: 'Fd',
      bcfq: 'Ff',
      bgfk: 'Fl',
      bcbc: 'Fo',
      bjck: 'Gd',
      bbgq: 'Gf',
      bbcc: 'Go',
      bfqc: 'Gr',

      aipq: 'Cb',
      aefk: 'Cl',
      aiqp: 'Db',
      aegj: 'Dl',
      ajoq: 'Eb',
      bjqq: 'Gb',
      bfgk: 'Gl',

      # "ghost/pov positions"
      aeei: 'Al',
      aeoa: 'Ar',
      aioo: 'Ab',
      bgpc: 'Fr',
      bkpq: 'Fb',
  }

  OLL_NAMES = {
      a1a1a1a1: :m0,
      a1a1a2a2: :m28,
      a1a1b1c1: :m24,
      a1a1b2c2: :m32,
      a1a1c1b1: :m23,
      a1a1c2b2: :m44,
      a1a2a1a2: :m57,
      a1a2b1c2: :m33,
      a1a2b2c1: :m31,
      a1a2c1b2: :m45,
      a1a2c2b1: :m43,
      a1b1a1c1: :m25,
      a1b1a2c2: :m36,
      a1b1b1b1: :m26,
      a1b1b2b2: :m12,
      a1b1c2a2: :m30,
      a1b2a1c2: :m39,
      a1b2a2c1: :m35,
      a1b2b1b2: :m16,
      a1b2b2b1: :m6,
      a1b2c1a2: :m34,
      a1c1a2b2: :m38,
      a1c1b2a2: :m41,
      a1c1c1c1: :m27,
      a1c1c2c2: :m7,
      a1c2a2b1: :m37,
      a1c2b1a2: :m46,
      a1c2c1c2: :m13,
      a1c2c2c1: :m5,
      a2a2a2a2: :m20,
      a2a2b1c1: :m29,
      a2a2b2c2: :m19,
      a2a2c1b1: :m42,
      a2a2c2b2: :m18,
      a2b1a2c1: :m40,
      a2b1b1b2: :m9,
      a2b1b2b1: :m14,
      a2b2a2c2: :m17,
      a2b2b1b1: :m8,
      a2b2b2b2: :m4,
      a2c1c1c2: :m10,
      a2c1c2c1: :m15,
      a2c2c1c1: :m11,
      a2c2c2c2: :m3,
      b1b1c1c1: :m22,
      b1b1c2c2: :m49,
      b1b2c1c2: :m52,
      b1b2c2c1: :m48,
      b1c1b1c1: :m21,
      b1c1b2c2: :m54,
      b1c1c2b2: :m50,
      b1c2b1c2: :m55,
      b1c2b2c1: :m53,
      b1c2c1b2: :m51,
      b2b2c1c1: :m47,
      b2b2c2c2: :m2,
      b2c1b2c1: :m56,
      b2c2b2c2: :m1,
  }

  EO_NAMES = {'1111'=>'4', '1122'=>'6', '1212'=>'1', '1221'=>'9', '2112'=>'7', '2121'=>'2', '2211'=>'8', '2222'=>'0'}

  EP_NAMES = {'1111'=>'A', '5555'=>'B', '7373'=>'C', '3737'=>'D', '1335'=>'E', '1577'=>'F',
              '5133'=>'G', '7157'=>'H', '3513'=>'I', '7715'=>'J', '3351'=>'K', '5771'=>'L',
              '7777'=>'a', '3333'=>'b', '1515'=>'c', '5151'=>'d', '3711'=>'e', '5735'=>'f',
              '1371'=>'g', '5573'=>'h', '1137'=>'i', '3557'=>'j', '7113'=>'k', '7355'=>'l'}
end