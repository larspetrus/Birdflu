# frozen_string_literal: true

class ComboAlg < ActiveRecord::Base
  belongs_to :alg1, class_name: RawAlg.name
  belongs_to :alg2, class_name: RawAlg.name
  belongs_to :combined_alg, class_name: RawAlg.name
  belongs_to :position
  has_many :stars, as: :starrable


  def self.construct(alg1, alg2, alg2_shift, combined_alg, cancel_count, merge_count)
    encoded_data = 100*alg2_shift + 10*cancel_count + merge_count

    ComboAlg.create!(alg1: alg1, alg2: alg2, combined_alg: combined_alg, position_id: combined_alg.position_id, encoded_data: encoded_data)
  end

  def self.make(a1, a2, u_shift)
    merge = Algs.merge_moves(Algs.official_variant(a1.moves), a2.algs(u_shift))
    return if merge[:moves].empty? # algs cancelled

    display_offset = Algs.display_offset(merge[:moves])
    merge.keys.each { |key| merge[key] = Algs.shift(merge[key], display_offset) }

    total_alg = RawAlg.with_moves(merge[:moves]) || self.maybe_create_alg(merge[:moves])
    if total_alg
      ComboAlg.construct(a1, a2, u_shift, total_alg, Algs.length(merge[:cancel1]), Algs.length(merge[:merged]))
    end
  end

  def presenter(context)
    ComboAlgColumns.new(self, context)
  end

  def self.maybe_create_alg(moves)
    Cube.by_alg(moves).standard_ll_code == 'a1a1a1a1' ? nil : RawAlg.make(moves, Algs.length(moves))
  end

  def self.make_4(a1, a2)
    0.upto(3) { |u_shift| make(a1, a2, u_shift) }
  end

  def self.combined_ids
    ComboAlg.select(:alg1_id).distinct.order(:alg1_id).pluck(:alg1_id)
  end

  def star_styles(wca_user_id)
    Galaxy.star_styles_for(wca_user_id, id, 'combo_alg')
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

  def length
    0
  end

  def speed
    0
  end

  def matches(search_term)
    search_term == "c#{id}"
  end

  def star_type
    'cstar';
  end

  def highlight_id
    "c#{id}"
  end

  def merge_display_data
    ComboAlg._merge_display_data(alg1, alg2, alg2_shift, cancel_count, merge_count)
  end

  def self._merge_display_data(alg1, alg2, alg2_shift, cancel_count, merge_count)
    net_cancel = cancel_count - merge_count

    ua1 = UiAlg.new(Algs.official_variant(alg1.moves))
    ua2 = UiAlg.new(RawAlg.make_non_db(alg2.moves).algs(alg2_shift))
    display_offset = Algs.display_offset(ua1 + ua2)

    remain1 = ua1.shift(display_offset).to_a
    cancel1 = []
    remain2 = ua2.shift(display_offset).to_a
    cancel2 = []

    cancel_count.times do |i|
      index1, index2 = -1, 0
      unless remain2.first[0] == remain1.last[0] # same side?
        if remain2.second[0] == remain1.last[0] then index2 = 1 else index1 = -2 end
      end
      cancel1.insert(0, remain1.delete_at(index1))
      cancel2 << remain2.delete_at(index2)
    end

    nb = "\u00A0" # non breaking space
    nc = net_cancel > 0 ? nb : ''
    [].tap do |result|
      result << [remain1.join(' ') + nb]
      result << [cancel1.first(merge_count).join(' ') + nc, :merged] if merge_count > 0
      result << [cancel1.last(net_cancel).join(' '), :cancel1] if net_cancel > 0
      result << [nc+'+'+nc]
      result << [cancel2.first(net_cancel).join(' '), :cancel2] if net_cancel > 0
      result << [nc + cancel2.last(merge_count).join(' '), :merged] if merge_count > 0
      result << [nb + remain2.join(' '), :alg2]
    end
  end


  def to_s
    "ComboAlg id: #{id}, name: #{name}, length: #{combined_alg.length}, alg1: #{alg1.moves}, alg2: #{alg2.moves} (#{alg2_shift}) combined: #{combined_alg.moves}, cancel: #{cancel_count}, merged: #{merge_count}"
  end
end
