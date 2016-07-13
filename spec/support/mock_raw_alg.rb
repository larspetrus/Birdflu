class MockRawAlg
  attr_reader :id, :name
  attr_accessor :find_mirror

  def initialize(id, name, find_mirror = nil)
    @id = id
    @name = name

    @find_mirror = find_mirror
    find_mirror.find_mirror = self if find_mirror
  end

  def <=>(other) id <=> other.id end
  def eql?(other) id == other.id end
  def hash() id end
end