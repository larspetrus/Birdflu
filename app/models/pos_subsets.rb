class PosSubsets
  def self.random_code(subset, contraints)
    case subset.to_sym
      when :cop, :oll
        Position.find(Position.random_id)[subset]
      when :eo
        ["1111", "1122", "1212", "1221", "2112", "2121", "2211", "2222"].sample
      when :ep
        self.ep_code_grid_by_cop(contraints[:cop]).flatten.sample
      else
        raise "Unknown position subset '#{subset}'"
    end
  end

  def self.ep_code_grid_by_cop(cop)
    @lower ||= %w(7777 3333 1515 5151 3711 5735 1371 5573 1137 3557 7113 7355)
    @upper ||= %w(1111 5555 7373 3737 1335 1577 5133 7157 3513 7715 3351 5771)

    case cop.to_sym
      when :Ao, :Bo, :Bb, :Bl, :Cb, :Cl, :Co, :Db, :Dl, :Do, :Eb, :El, :Eo, :Fl, :Fo, :Gb, :Gl, :Go, :bb, :bl, :bo
        [@upper]
      when :Ad, :Af, :Bd, :Bf, :Br, :Cd, :Cf, :Cr, :Dd, :Df, :Dr, :Ed, :Ef, :Er, :Fd, :Ff, :Gd, :Gf, :Gr, :bd, :bf, :br
        [@lower]
      else
        [@upper, @lower]
    end
  end
end
