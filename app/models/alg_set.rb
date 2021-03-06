# frozen_string_literal: true

class AlgSet < ApplicationRecord
  ARE_WE_ADMIN = Rails.env.development?

  belongs_to :wca_user, optional: true

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
    self.algs ||= ''
    self.algs = self.algs.split(' ').uniq.sort.join(' ') # sort names
  end


  attr_accessor :editable_by_this_user # Set by controller

  def self.make(algs: nil, name: '--', subset: 'all')
    algs = algs.join(' ') if algs.respond_to? :join
    AlgSet.create!(subset: subset, name: name, algs: algs, wca_user_id: nil)
  end

  before_save do
    fact.save!
  end

  def self.for_user(wca_user_id)
    AlgSet.where("predefined=true OR wca_user_id=#{wca_user_id || '-99'}")
  end

  def fact
    @fact ||= AlgSetFact.find_or_create_by!(algs_code: set_code).tap do |fact|
      fact.alg_set = self
      self.alg_set_fact_id = fact.id
    end
  end

  def replace_algs(new_algs)
    self.algs = new_algs
    self.alg_set_fact_id = nil
    @fact = nil
    self
  end

  def set_code
    (algs+' ').gsub(/\.\D[0-9\-]* /, '').strip + subset.first
  end

  def data_only
    fact.data_only
    self
  end

  def pos_subset
    case subset
      when 'all' then Position.real
      when 'eo'  then Position.real.where(eo: '4')
      else raise "Invalid subset '#{subset}'"
    end
  end

  @@pos_ids = {} # cache position ids per subset (all/eo)
  def subset_pos_ids
    @@pos_ids[subset] ||= pos_subset.pluck(:id)
  end

  def applies_to(position)
    position.eo == '4' || subset == 'all'
  end

  def include?(combo_alg)
    ids.include?(combo_alg.alg1_id) && ids.include?(combo_alg.alg2_id)
  end

  def has_facts
    fact.fully_computed?
  end

  def ids
    @ids ||= ('Nothing.-- ' + algs).split(' ').map { |ma_name| MirrorAlgs.combined(ma_name).ids }.flatten.sort.freeze
  end

  def mirror_algs
    algs.split(' ').map { |ma_name| MirrorAlgs.combined(ma_name) }
  end

  def full_coverage?
    return nil unless fact.coverage
    fact.coverage == subset_pos_ids.count
  end

  def uncovered_ids
    fact.uncovered_ids
  end

  def uncovered_ids_arr
    fact.uncovered_ids.split(' ')
  end

  def average(by_measure)
    case by_measure.to_sym
      when :speed  then fact.average_speed
      when :length then fact.average_length
      else raise "Unknown measure '#{by_measure}'"
    end
  end

  def dropdown_name
    dash = predefined ? '-' : '·'
    subset + dash + name
  end

  # This is to move AlgSets between dev and prod
  def to_yaml
    excluded_columns = %w(id created_at updated_at wca_user_id alg_set_fact_id)
    values = attributes.delete_if { |key, value| excluded_columns.include?(key) }

    # AlgSets made here are either predefined or owned by Lars.
    unless values['predefined']
      values['wca_user_id'] = WcaUser.find_by!(wca_id: '1982PETR01').id
    end

    YAML.dump(values)
  end

  def self.from_yaml(yaml_string)
    create!(YAML.load(yaml_string))
  end

  def to_s
    "AlgSet #{id}: '#{name}' (#{subset})"
  end

  # -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+- -+=+-

  def self.menu_options(login)
    sets = AlgSet.for_user(login&.db_id).to_a
    sets.sort_by {|as| [as.predefined ? 0 : 1, as.subset, as.algs.length] }.map{|as| [as.dropdown_name, as.id] }
  end

  SMALL_39 = %w(F1.F3 F2.F4 G1.G6 G2.G7 G3.G9 G4.G8 G5.G10 H12.H31 H15.H33 H16.H35 H5.H29 I19.I70 I3.I63 I54.I114 J101.J423 J103.J401 J112.J409 J126.J368 J132.J371 J16.J325 J179.J487 J183.J483 J199.J495 J204.J502 J211.J517 J212.J519 J219.J528 J266.J538 J275.J550 J34.J39 J629.J652 J637.J657 J639.J658 J78.J387 J82.J390 J93.J417 J95.J416 J98.J419 J99.J421)
  QUICK_49 = %w(F2.F4 G2.G7 G3.G9 G4.G8 G5.G10 H15.H33 H16.H35 H17.H36 H19.H38 H6.H30 H9.H23 I19.I70 I21.I67 I3.I63 I49.I105 I58.I115 I59.I116 J103.J401 J110.J411 J112.J409 J126.J368 J131.J370 J140.J382 J16.J325 J183.J483 J199.J495 J204.J502 J212.J519 J216.J521 J219.J528 J246.J455 J266.J538 J34.J39 J49.J54 J629.J652 J637.J657 J82.J390 J93.J417 J95.J416 J97.J420 J99.J421 F1.F3 G1.G6 H8.H22 H13.H34 J98.J419 I55.I110 J301.J571 H14.H32)
  FEW_49 = %w(F2.F4 G1.G6 G2.G7 G3.G9 G4.G8 G5.G10 H1.H25 H11.H21 H12.H31 H14.H32 H15.H33 H16.H35 H5.H29 H8.H22 I19.I70 I22.I72 I3.I63 I30.I90 I54.I114 I59.I116 J101.J423 J103.J401 J112.J409 J119.J372 J126.J368 J146.J431 J16.J325 J179.J487 J183.J483 J199.J495 J204.J502 J212.J519 J266.J538 J34.J39 J629.J652 J637.J657 J638.J659 J639.J658 J77.J385 J93.J417 J95.J416 J98.J419 J99.J421 F1.F3 H3.H28 I55.I110 H2.H27 I58.I115 H6.H30)

  EO_SMALL_14 = %w(G3.G9 G4.G8 G5.G10 J252.J470 J44.J45 I129.I137 J266.J538 I120.I125 J51.J56 I28.I88 J112.J409 J260.J467 I20.I68 J93.J417)
end
