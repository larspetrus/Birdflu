# A MirrorAlgs object contains a RawAlg and its mirror alg. A few algs are their own mirrors.

class MirrorAlgs
  attr_reader :name, :ids, :algs

  def initialize(alg, mirror_alg)
    @algs = [alg, mirror_alg].compact.uniq.sort
    @name = @algs[0].name + '.' + (@algs[1]&.name || '--')
    @ids = @algs.map(&:id)
  end

  def to_s
    "#{@name} #{ids}"
  end

  def self.raw_alg_ids_from(mirror_algs)
    mirror_algs.reduce([]){|all, ma| all += ma.ids}.sort.uniq
  end

  # Make MirrorAlgs of *all* RawAlgs that have been combined into ComboAlgs
  def self._combined_data
    @combined_data ||= begin
      {}.tap do |result|
        RawAlg.where(id: ComboAlg.distinct.pluck(:alg2_id).sort).each do |alg|
          mirror = alg.find_mirror
          if !mirror || alg.id <= mirror.id
            malg = MirrorAlgs.new(alg, mirror)
            result[malg.name] = malg
          end
        end
        result.freeze
      end
    end
  end

  def self.all_combined
    _combined_data.values
  end

  def self.all_names
    @all_names ||= self.all_combined.map(&:name)
  end

  def self.k_plus_names
    @k_plus_names ||= self.all_names.select{|malg| malg.first > "J" && malg != "Nothing.--" }
  end

  def self.combined_name_for(alg_or_pair)
    @name_map ||= self.all_names.map{|aa| [[aa, aa]] + aa.split('.').map{|a| [a, aa]}}.reduce(&:+).reject{|pair| pair.first == '--'}.to_h
    @name_map[alg_or_pair.to_s.upcase]
  end

  def self.combined(mirror_alg_name)
    _combined_data[mirror_alg_name]
  end

  def self.combineds(mirror_alg_names)
    mirror_alg_names.map{|name| MirrorAlgs.combined(name) }
  end

end