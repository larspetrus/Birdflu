class MirrorAlgs
  attr_reader :name, :ids

  def initialize(alg, mirror_alg)
    algs = [alg, mirror_alg].compact.sort
    @name = algs[0].name + '·' + (algs[1]&.name || '--')
    @ids = algs.map(&:id)
  end

  def to_s
    "#{@name} [#{ids}]"
  end

  def self.raw_alg_ids_from(mirror_algs)
    mirror_algs.reduce([]){|all, ma| all += ma.ids}.sort.uniq
  end

  def self.make_all(raw_algs)
    result = []
    already_paired = Set.new

    raw_algs.each do |alg|
      unless already_paired.include?(alg.id)
        result << MirrorAlgs.new(alg, alg.find_mirror)
        already_paired += result.last.ids
      end
    end
    result
  end
end