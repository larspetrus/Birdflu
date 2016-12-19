# frozen_string_literal: true

class AlgSet < ActiveRecord::Base
  ARE_WE_ADMIN = Rails.env.development?

  belongs_to :wca_user

  validates :name, presence: true
  validates_inclusion_of :subset, :in => %w(all eo)

  validate do
    algs.split(' ').each do |mirror_alg_name|
      ma = MirrorAlgs.combined(mirror_alg_name)

      errors.add(:algs, "'#{mirror_alg_name}' is not a valid mirrored alg pair") unless ma
      errors.add(:algs, "'Nothing' is not a real alg") if ma&.ids == [RawAlg::NOTHING_ID]
    end

  end

  before_validation do
    self.algs = self.algs.split(' ').uniq.sort.join(' ') # sort names
  end

  attr_accessor :editable_by_this_user

  def self.make(algs:, name:, subset: 'all')
    algs = algs.join(' ') if algs.respond_to? :join
    AlgSet.create(subset: subset, name: name, algs: algs)
  end

  CACHE_KEYS = [:coverage, :lengths, :speeds, :average_length, :average_speed]

  def computing_off
    @computing_off = true
    self
  end

  def pos_subset
    case subset
      when 'all'
        Position.real
      when 'eo'
        Position.real.where(eo: '4')
      else
        raise "Invalid subset '#{subset}'"
    end
  end

  @@pos_ids = {} # cache position ids per subset (all/eo)
  def subset_pos_ids
    @@pos_ids[subset] ||= pos_subset.pluck(:id)
  end

  @@weights = {} # cache total weight per subset
  def subset_weight
    @@weights[subset] ||= pos_subset.sum(:weight)
  end

  def include?(combo_alg)
    ids.include?(combo_alg.alg1_id) && ids.include?(combo_alg.alg2_id)
  end

  def cache(key)
    raise "Unknown cache key #{key}" unless CACHE_KEYS.include? key

    if @computing_off
      computed_data[key]
    else
      computed_data[key] ||= yield
    end
  end

  def recompute_cache(keys = CACHE_KEYS)
    # this ignores dependencies, so recomputing :lengths but not :average_length is probably wrong!
    keys.each { |key| @computed_data.delete(key)}
    save_cache
  end

  def save_cache
    [:length, :speed].each { |measure| average(measure) }
    coverage

    uncomputed_keys = CACHE_KEYS - @computed_data.keys
    raise "Uncomputed keys: #{uncomputed_keys}" if (uncomputed_keys).present?

    self._cached_data = YAML.dump(@computed_data)
    save
  end

  def computed
    _cached_data.present?
  end

  def computed_data
    @computed_data ||= (_cached_data ? YAML.load(_cached_data) : {})
  end

  def ids
    @ids ||= ('Nothing.-- ' + algs).split(' ').map { |ma_name| MirrorAlgs.combined(ma_name).ids }.flatten.sort.freeze
  end

  def coverage
    cache(:coverage) do
      subset_pos_ids.count{|id| lengths[id].present? }
    end
  end

  def full_coverage?
    return nil unless coverage
    coverage == subset_pos_ids.count
  end

  def uncovered_ids
    @unc ||= subset_pos_ids.select{|id| lengths[id].nil? }
  end

  def covered_weight
    @cw ||= pos_subset.reduce(0.0) { |sum, pos| sum + (lengths[pos.id].nil? ? 0 : pos.weight)}
  end

  def average(by_measure)
    case by_measure.to_sym
      when :speed
        self.average_speed
      when :length
        self.average_length
      else
        raise "Unknown measure '#{by_measure}'"
    end
  end

  def lengths
    cache(:lengths) do
      Array.new(Position::MAX_REAL_ID + 1).tap do |result|
        pos_subset.find_each { |pos| result[pos.id] = pos.algs_in_set(self, sortby: 'length', limit: 1).first&.length }
        result[RawAlg::NOTHING_ID] = 0
      end
    end
  end

  def average_length
    cache(:average_length) do
      pos_subset.reduce(0.0) { |sum, pos| sum + (self.lengths[pos.id] || 0)*pos.weight }/covered_weight
    end
  end

  def speeds
    cache(:speeds) do
      Array.new(Position::MAX_REAL_ID + 1).tap do |result|
        pos_subset.find_each{|pos| result[pos.id] = pos.algs_in_set(self, sortby: '_speed', limit: 1).first&.speed }
        result[RawAlg::NOTHING_ID] = 0.0
      end
    end
  end

  def average_speed
    cache(:average_speed) do
      pos_subset.reduce(0.0) { |sum, pos| sum + (self.speeds[pos.id] || 0)*pos.weight }/covered_weight
    end
  end

  def dropdown_name
    "#{name}·#{subset}"
  end

  def to_s
    "AlgSet #{id}: '#{name}' (#{subset})"
  end

  # -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+-

  def self.menu_options
    AlgSet.all.to_a.sort_by {|as| [as.predefined ? 0 : 1, as.subset, as.algs.length] }.map{|as| [as.dropdown_name, as.id] }
  end

  SMALL_39 = %w(F1.F3 F2.F4 G1.G6 G2.G7 G3.G9 G4.G8 G5.G10 H12.H31 H15.H33 H16.H35 H5.H29 I19.I70 I3.I63 I54.I114 J101.J423 J103.J401 J112.J409 J126.J368 J132.J371 J16.J325 J179.J487 J183.J483 J199.J495 J204.J502 J211.J517 J212.J519 J219.J528 J266.J538 J275.J550 J34.J39 J629.J652 J637.J657 J639.J658 J78.J387 J82.J390 J93.J417 J95.J416 J98.J419 J99.J421)
  QUICK_49 = %w(F2.F4 G2.G7 G3.G9 G4.G8 G5.G10 H15.H33 H16.H35 H17.H36 H19.H38 H6.H30 H9.H23 I19.I70 I21.I67 I3.I63 I49.I105 I58.I115 I59.I116 J103.J401 J110.J411 J112.J409 J126.J368 J131.J370 J140.J382 J16.J325 J183.J483 J199.J495 J204.J502 J212.J519 J216.J521 J219.J528 J246.J455 J266.J538 J34.J39 J49.J54 J629.J652 J637.J657 J82.J390 J93.J417 J95.J416 J97.J420 J99.J421 F1.F3 G1.G6 H8.H22 H13.H34 J98.J419 I55.I110 J301.J571 H14.H32)
  FEW_49 = %w(F2.F4 G1.G6 G2.G7 G3.G9 G4.G8 G5.G10 H1.H25 H11.H21 H12.H31 H14.H32 H15.H33 H16.H35 H5.H29 H8.H22 I19.I70 I22.I72 I3.I63 I30.I90 I54.I114 I59.I116 J101.J423 J103.J401 J112.J409 J119.J372 J126.J368 J146.J431 J16.J325 J179.J487 J183.J483 J199.J495 J204.J502 J212.J519 J266.J538 J34.J39 J629.J652 J637.J657 J638.J659 J639.J658 J77.J385 J93.J417 J95.J416 J98.J419 J99.J421 F1.F3 H3.H28 I55.I110 H2.H27 I58.I115 H6.H30)

  EO_SMALL_14 = %w(G3.G9 G4.G8 G5.G10 J252.J470 J44.J45 I129.I137 J266.J538 I120.I125 J51.J56 I28.I88 J112.J409 J260.J467 I20.I68 J93.J417)
end
