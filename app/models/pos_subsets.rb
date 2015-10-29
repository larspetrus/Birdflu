class PosSubsets
  def self.random_code(subset, contraints)
    case subset.to_sym
      when :cop, :oll
        Position.find(Position.random_id)[subset]
      when :eo
        %w(0 1 2 4 6 7 8 9).sample
      when :ep
        self.ep_code_grid_by_cop(contraints[:cop]).flatten.sample
      else
        raise "Unknown position subset '#{subset}'"
    end
  end

  def self.ep_code_grid_by_cop(cop)
    @upper ||= %w(A B C D E F G H I J K L)
    @lower ||= %w(a b c d e f g h i j k l)

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
