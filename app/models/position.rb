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
      if pos.ll_code != mirror_pos.mirror_ll_code || pos.mirror_ll_code != mirror_pos.ll_code
        errors << "Mirror problem: Position id: #{pos.id}, ll_code: #{pos.ll_code}"
      end

      cl_msg = "Unmatched corner looks '#{pos.corner_look}' <=> '#{mirror_pos.corner_look}': #{pos_id}"
      case pos.corner_look
        when 'B1'
          errors << cl_msg unless mirror_pos.corner_look == 'B2'
        when 'B2'
          errors << cl_msg unless mirror_pos.corner_look == 'B1'
        else
          errors << cl_msg unless mirror_pos.corner_look == pos.corner_look
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

end
