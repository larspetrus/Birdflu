# frozen_string_literal: true

class ComboAlg < ActiveRecord::Base
  belongs_to :alg1, class_name: RawAlg.name
  belongs_to :alg2, class_name: RawAlg.name
  belongs_to :combined_alg, class_name: RawAlg.name

  def self.construct(alg1, alg2, alg2_shift, combined_alg, cancel_count, merge_count)
    encoded_data = 100*alg2_shift + 10*cancel_count + merge_count

    ComboAlg.create(alg1: alg1, alg2: alg2, combined_alg: combined_alg, encoded_data: encoded_data)
  end

  def self.make(a1, a2, u_shift)
    merge = Algs.merge_moves(Algs.official_variant(a1.moves), a2.algs(u_shift))
    return if merge[:moves].empty? # algs cancelled

    self.align_moves(merge)
    total_alg = RawAlg.find_from_moves(merge[:moves]) || self.maybe_create_alg(merge[:moves])
    if total_alg
      ComboAlg.construct(a1, a2, u_shift, total_alg, Algs.length(merge[:cancel1]), Algs.length(merge[:merged]))
    end
  end

  def self.maybe_create_alg(moves)
    Cube.new(moves).standard_ll_code == 'a1a1a1a1' ? nil : RawAlg.make(moves, Algs.length(moves))
  end

  def self.make_4(a1, a2)
    0.upto(3) { |u_shift| make(a1, a2, u_shift) }
  end

  def self.align_moves(move_parms)
    display_offset = Algs.display_offset(move_parms[:moves])
    move_parms.keys.each { | key | move_parms[key] = Algs.shift(move_parms[key], display_offset) }
  end

  def self.combined_ids
    ComboAlg.select(:alg1_id).distinct.order(:alg1_id).pluck(:alg1_id)
  end

  def alg2_shift
    encoded_data / 100
  end

  def cancel_count
    (encoded_data % 100) / 10
  end

  def merge_count
    encoded_data % 10
  end

  def name
    "#{alg1.name}+#{alg2.name}"
  end

  def recon
    ComboAlg.display_merge(alg1, alg2, alg2_shift, cancel_count, merge_count)
  end

  def self.display_merge(alg1, alg2, alg2_shift, cancel_count, merge_count)
    ua1 = UiAlg.new(Algs.official_variant(alg1.moves))
    ua2 = UiAlg.new(Algs.shift(Algs.official_variant(alg2.moves), alg2_shift))
    display_offset = Algs.display_offset(ua1 + ua2)
    ua1 = UiAlg.new(Algs.shift(ua1, display_offset))
    ua2 = UiAlg.new(Algs.shift(ua2, display_offset))

    da1, da2 = ua1.db_alg, ua2.db_alg

    untouched1, cancel1 = da1.not_last(cancel_count), da1.last(cancel_count)
    cancel2, untouched2 = da2.first(cancel_count), da2.not_first(cancel_count)

    net_cancel = cancel_count - merge_count
    nbsp = "\u00A0"
    _nc_ = net_cancel > 0 ? nbsp : ''
    [].tap do |result|
      result << [untouched1.ui_alg.to_s + nbsp]
      result << [cancel1.first(merge_count).ui_alg.to_s + _nc_, :merged] if merge_count > 0
      result << [cancel1.last(net_cancel).ui_alg.to_s, :cancel1] if net_cancel > 0
      result << [_nc_ + '+' + _nc_]
      result << [cancel2.first(net_cancel).ui_alg.to_s, :cancel2] if net_cancel > 0
      result << [_nc_ + cancel2.last(merge_count).ui_alg.to_s, :merged] if merge_count > 0
      result << [nbsp + untouched2.ui_alg.to_s, :alg2]
    end
  end


  def to_s
    "ComboAlg id: #{id}, name: #{name}, length: #{combined_alg.length}, alg1: #{alg1.moves}, alg2: #{alg2.moves} (#{alg2_shift}) combined: #{combined_alg.moves}, cancel: #{cancel_count}, merged: #{merge_count}"
  end
end
