class Move
  attr_reader :cycles, :shift

  def initialize(cycles, shift)
    @cycles = cycles
    @shift = shift
  end

  R = Move.new([%i[URF DFR DRB UBR], %i[UR FR DR BR]], {B: :D, D: :F, F: :U, U: :B, L: :L, R: :R})
  L = Move.new([%i[ULB DBL DLF UFL], %i[BL DL FL UL]], {B: :U, U: :F, F: :D, D: :B, L: :L, R: :R})
  F = Move.new([%i[DLF DFR URF UFL], %i[FL DF FR UF]], {U: :R, R: :D, D: :L, L: :U, F: :F, B: :B})
  B = Move.new([%i[ULB UBR DRB DBL], %i[UB BR DB BL]], {U: :L, L: :D, D: :R, R: :U, F: :F, B: :B})
  U = Move.new([%i[UBR ULB UFL URF], %i[UR UB UL UF]], {F: :L, L: :B, B: :R, R: :F, U: :U, D: :D})
  D = Move.new([%i[DFR DLF DBL DRB], %i[DF DL DB DR]], {F: :R, R: :B, B: :L, L: :F, U: :U, D: :D})

  def self.on(side)
    case side.to_s
      when 'R' then R
      when 'L' then L
      when 'F' then F
      when 'B' then B
      when 'U' then U
      when 'D' then D
      else
        raise "Unknown side '#{side}' (#{side.class})"
    end
  end

  def self.parse(move)
    OpenStruct.new(side: move[0].to_sym, turns: {"2" => 2, "'" => 3}[move[1]] || 1)
  end

  def self.from(side, turns)
    turn_code = [nil, "", "2", "'"]
    "#{side}#{turn_code[turns]}"
  end

end