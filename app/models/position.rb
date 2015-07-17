# The Positions table contains a static data set of 3916 LL positions. Once initialized, it will never
# change. It could live in memory instead of (or in addition to) the DB, and maybe that's a future feature.
class Position < ActiveRecord::Base
  has_many :combo_algs, -> { order "length, base_alg2_id DESC" }
  belongs_to :best_alg, class_name: 'ComboAlg'

  enum corner_swap: [ :no, :left, :right, :back, :front, :diagonal]

  validates :ll_code, uniqueness: true

  before_create do
    self.oriented_edges = ll_code.count '1357'
    self.oriented_corners = ll_code.count 'aeio'
    self.set_corner_swap
    self.set_mirror_ll_code
    self.set_corner_look
    self.set_is_mirror
    self.set_oll
  end

  def self.corner_swap_for(ll_code)
    d2 = LL.corner_data(ll_code[2]).distance
    d3 = LL.corner_data(ll_code[4]).distance

    case "#{d2}#{d3}"
      when '00' then :no
      when '23' then :back
      when '13' then :right
      when '01' then :front
      when '11' then :left
      when '20' then :diagonal
    end
  end

  CP_SYMS = {'diagonal'=>'⤢', 'no'=>'', 'front'=>'F', 'left'=>'L', 'back'=>'B', 'right'=>'R'} #↕↔
  def corner_swap_symbol
    CP_SYMS[corner_swap]
  end

  def as_roofpig_tweaks()
    result = []
    4.times do |i|
      c_data = LL.corner_data(ll_code[i*2])
      corner_colors = c_data.position(i).chars.rotate(-c_data.spin).join

      e_data = LL.edge_data(ll_code[i*2 + 1])
      edge_colors = e_data.position(i).chars.rotate(e_data.spin).join

      result << "#{corner_colors}:#{LL.corners[i]}" << "#{edge_colors}:#{LL.edges[i]}"
    end
    result.join(' ')
  end

  def as_cube
    @cube ||= Cube.new.apply_position(ll_code)
  end

  def has_mirror
    ll_code != mirror_ll_code
  end

  def oll_code
    oll_codes = Cube.new.apply_position(ll_code).ll_codes.map do |code|
      oll_code_for(code)
    end
    oll_codes.sort.first
  end

  def oll_code_for(code)
    result = ''
    code.split('').each do |c|
      case c
        when 'a', 'e', 'i', 'o'
          result += 'a'
        when 'b', 'f', 'j', 'p'
          result += 'b'
        when 'c', 'g', 'k', 'q'
          result += 'c'
        when '1', '3', '5', '7'
          result += '1'
        when '2', '4', '6', '8'
          result += '2'
      end
    end
    result
  end

  def best_alg_length
    best_alg ? best_alg.length : 99
  end

  def set_corner_swap
    self.corner_swap = Position.corner_swap_for(ll_code)
  end

  def set_corner_look
    corner_look_code = (ll_code[0] + ll_code[2] + ll_code[4] + ll_code[6]).to_sym
    self.corner_look = CORNER_LOOK_MAP[corner_look_code]
  end

  def set_mirror_ll_code
    self.mirror_ll_code = Cube.new.apply_position(ll_code).standard_ll_code(:mirror)
  end

  def set_is_mirror
    self.is_mirror = ll_code < mirror_ll_code    #completely arbitrary
  end

  def set_oll
    self.oll = OLL_MAP[oll_code.to_sym]
  end

  def self.update_each
    Position.all.each do |pos|
      yield(pos)
      pos.save
    end
  end

  def self.generate_all # All LL positions
    corner_positioning_algs = [
      "",                                    # corners in place
      "R' F R' B2 R F' R' B2 R2",            # three cycle
      "F R' F' L F R F' L2 B' R B L B' R' B" # diagonal swap
    ]

    edge_positioning_algs = [
      "",
      "F2 U R' L F2 R L' U F2",  #Allans
      "F2 U' L R' F2 L' R U' F2",
      "L2 U F' B L2 F B' U L2",
      "L2 U' B F' L2 B' F U' L2",
      "B2 U L' R B2 L R' U B2",
      "B2 U' R L' B2 R' L U' B2",
      "R2 U B' F R2 B F' U R2",
      "R2 U' F B' R2 F' B U' R2",
      "R2 F2 B2 L2 D L2 B2 F2 R2", # Arne
      "F2 B2 D R2 F2 B2 L2 F2 B2 D' F2 B2", # Berts
      "F2 B2 D' R2 F2 B2 L2 F2 B2 D F2 B2",
    ]

    found_positions = Hash.new(0)

    corner_positioning_algs.each do |cp_alg|
      edge_positioning_algs.each do |ep_alg|
        cube = Cube.new.setup_alg(cp_alg).setup_alg(ep_alg)
        untwisted_ll_code = cube.ll_codes[0].bytes

        (0..2).each do |c1|
          (0..2).each do |c2|
            (0..2).each do |c3|

              (0..1).each do |e1|
                (0..1).each do |e2|
                  (0..1).each do |e3|
                    twists = [c1, e1, c2, e2, c3, e3, (-c1-c2-c3) % 3, (e1+e2+e3) % 2]
                    twisted_code = (0..7).inject('') { |code, i| code.concat(untwisted_ll_code[i]+twists[i]) }

                    found_positions[Cube.new.apply_position(twisted_code).standard_ll_code] += 1
                  end
                end
              end

            end
          end
        end

      end
    end
    found_positions.each { |code, weight| Position.create(ll_code: code, weight: weight) }
  end

  def self.sanity_check
    errors = []

    Position.all.each do |pos|
      pos_id = "Position id: #{pos.id}, ll_code: #{pos.ll_code}"
      mirror_pos = Position.find_by!(ll_code: pos.mirror_ll_code)

      # Do mirrors match?
      if pos.ll_code != mirror_pos.mirror_ll_code || pos.mirror_ll_code != mirror_pos.ll_code
        errors << "Mirror problem: #{pos_id}"
      end

      # Do the corner looks match?
      cl_msg = "Unmatched corner looks '#{pos.corner_look}' <=> '#{mirror_pos.corner_look}': #{pos_id}"
      case pos.corner_look
        when 'B1'
          errors << cl_msg unless mirror_pos.corner_look == 'B2'
        when 'B2'
          errors << cl_msg unless mirror_pos.corner_look == 'B1'
        else
          errors << cl_msg unless mirror_pos.corner_look == pos.corner_look
      end

      # Is is_mirror consistent?
      if pos.ll_code == pos.mirror_ll_code
        errors << "Selfmirrored problem: #{pos_id}" if pos.is_mirror
      else
        errors << "Too many mirrors: #{pos_id}" if pos.is_mirror && mirror_pos.is_mirror
        errors << "Too few mirrors: #{pos_id}" if !pos.is_mirror && !mirror_pos.is_mirror
      end
    end

    puts "-"*88, errors
    puts "Error count: #{errors.size}"
  end

  CORNER_LOOK_MAP = {
      aaaa: 'A',
      aabc: 'C',
      aacb: 'D',
      aaeo: 'A',
      aafq: 'C',
      aagp: 'D',
      abac: 'E',
      abbb: 'B2',
      abca: 'C',
      abeq: 'E',
      abfp: 'B2',
      abgo: 'C',
      acab: 'E',
      acba: 'D',
      accc: 'B1',
      acep: 'E',
      acfo: 'D',
      acgq: 'B1',
      aeei: 'A',
      aeoa: 'A',
      aefk: 'C',
      aepc: 'C',
      aegj: 'D',
      aeqb: 'D',
      afek: 'E',
      affj: 'B2',
      afgi: 'C',
      afoc: 'E',
      afpb: 'B2',
      afqa: 'C',
      agej: 'E',
      agfi: 'D',
      aggk: 'B1',
      agob: 'E',
      agpa: 'D',
      agqc: 'B1',
      aiai: 'A',
      aibk: 'C',
      aicj: 'D',
      aioo: 'A',
      aipq: 'C',
      aiqp: 'D',
      ajak: 'E',
      ajbj: 'B2',
      ajci: 'C',
      ajoq: 'E',
      ajpp: 'B2',
      ajqo: 'C',
      akaj: 'E',
      akbi: 'D',
      akck: 'B1',
      akop: 'E',
      akpo: 'D',
      akqq: 'B1',
      bbcc: 'G',
      bbgq: 'G',
      bcbc: 'F',
      bccb: 'G',
      bcfq: 'F',
      bcgp: 'G',
      bfgk: 'G',
      bfqc: 'G',
      bgfk: 'F',
      bggj: 'G',
      bgpc: 'F',
      bgqb: 'G',
      bjck: 'G',
      bjqq: 'G',
      bkbk: 'F',
      bkcj: 'G',
      bkpq: 'F',
      bkqp: 'G',
  }

  OLL_MAP = {
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

end
