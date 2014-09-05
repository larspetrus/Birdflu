class LlComboAlg

  def initialize(alg1, alg2)
    @alg1 = alg1
    @alg2 = alg2
    @combo = LlAlg.new("#{@alg1.name}+#{@alg2.name}", LlComboAlg.merge_moves(@alg1.moves, @alg2.moves))
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

  def ll_code_by_moves()
    @combo.solves_ll_code
  end

  def name
    @combo.name
  end

  def length
    @combo.length
  end

  def moves
    @combo.moves
  end

  def nl
    @combo.nl
  end
end