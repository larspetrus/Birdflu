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
    merge_result = Algs.merge_moves(Algs.official_variant(a1.moves), a2.algs(u_shift))
    return if merge_result[:moves].empty? # algs cancelled

    self.align_moves(merge_result)
    ComboAlg.construct(a1, a2, u_shift, RawAlg.find_from_moves(merge_result[:moves]), Algs.length(merge_result[:cancel1]), Algs.length(merge_result[:merged]))
  end

  def self.make_4(a1, a2)
    0.upto(3) { |u_shift| make(a1, a2, u_shift) }
  end

  def self.align_moves(move_parms)
    display_offset = Algs.display_offset(move_parms[:moves])
    move_parms.keys.each { | key | move_parms[key] = Algs.rotate_by_U(move_parms[key], display_offset) }
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

  def to_s
    "ComboAlg id: #{id}, name: #{name}, length: #{combined_alg.length}, alg1: #{alg1.moves}, alg2: #{alg2.moves} combined: #{combined_alg.moves}, cancel: #{cancel_count}, merged: #{merge_count}"
  end
end