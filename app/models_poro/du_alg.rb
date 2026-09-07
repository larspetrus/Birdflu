class DuAlg
  attr_reader :as_str, :as_list

  FACES = %w[B R D F L U].freeze

  VALID_MOVES = {
    MoveSet::BRDFLU => FACES,
    MoveSet::XYZ    => FACES + %w[x y z],
    MoveSet::ALL    => FACES + %w[x y z M E S b r d f l u]
  }.transform_values(&:freeze).freeze

  def self.new(*args)  # Optimization: Override .new() to return the passed in DuAlg instead of copying it
    return args.first if args.first.is_a?(DuAlg)
    super
  end

  def initialize(alg, moveset = MoveSet::ALL)
    if alg.is_a?(String)
      @as_str = alg
      @as_list = alg.split(' ')
    elsif alg.is_a?(Array)
      @as_str = alg.join(' ')
      @as_list = alg
    else
      raise "Invalid constructor argument type: #{alg.class.name} (#{alg.inspect})"
    end

    for move in @as_list
      unless VALID_MOVES[moveset].include?(move[0]) and [nil, "'", "2"].include?(move[1]) and move.length <= 2
        raise "Invalid move: #{move}"
      end
    end
  end

  def eql?(other)
    if other.is_a?(DuAlg) && as_str == other.as_str # identical DuAlg
      return true
    end

    as_str == other || as_list == other
  end

  alias == eql?  # Needed!

  def to_s
    "[DuAlg: #{as_str}]"
  end

end
