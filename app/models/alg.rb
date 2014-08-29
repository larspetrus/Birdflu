class Alg < ActiveRecord::Base
  attr_reader :name, :moves

  def self.variants(name, moves)
    circle = {'R'=>'F', 'F'=>'L', 'L'=>'B', 'B'=>'R'}

    result = []
    4.times do
      result << Alg.new(name + "-#{moves.split(' ').first}", moves)
      moves = moves.chars.map { |char| circle[char] || char}.join
    end
    result
  end

  def initialize(name, moves)
    @name = name
    @moves = moves
  end

  def to_s
    "#{@name}: #{@moves}"
  end
end
