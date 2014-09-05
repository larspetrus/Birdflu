class LlAlg
  attr_reader :name, :moves, :primary, :solves_ll_code

  def self.combo(alg1, alg2)
    LlAlg.new("#{alg1.name}+#{alg2.name}", LlAlg.merge_moves(alg1.moves, alg2.moves))
  end

  def self.merge_moves(moves1, moves2)
    split1 = moves1.split(' ')
    split2 = moves2.split(' ')

    begin
      m1 = Move.parse(split1.last)
      m2 = Move.parse(split2.first)
      double_cancel = (m1.side == m2.side) && (m1.turns + m2.turns == 4)
      if m1.side == m2.side
        split1.delete_at(split1.length-1)
        split2.delete_at(0)

        split1 << Move.from(m1.side, (m1.turns + m2.turns) % 4) unless double_cancel
      end
    end while double_cancel && split1.length > 0 && split2.length > 0

    (split1 + split2).join(' ')
  end

  def initialize(name, moves, primary = false)
    @name = name
    @moves = moves
    @solves_ll_code = Cube.new.setup_alg(moves).standard_ll_code
    @primary = primary
  end

  def to_s
    "#{@name}: #{@moves}"
  end

  def length
    @moves.split(' ').length
  end

  def nl
    "#{length} #{name}"
  end
end
