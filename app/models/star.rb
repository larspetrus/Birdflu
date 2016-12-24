# frozen_string_literal: true

class Star < ActiveRecord::Base
  belongs_to :galaxy
  belongs_to :starrable, polymorphic: true

  validates :starred_id, numericality: { only_integer: true, greater_than: 0 }

  def self.select_from_class(star_class)
    return [  'raw_alg', Integer(star_class[4..-1])] if star_class.start_with? 'star'
    return ['combo_alg', Integer(star_class[5..-1])] if star_class.start_with? 'cstar'

    raise "Bad Star class '#{star_class}'"
  end

  def alg
    case galaxy.starred_type
      when 'raw_alg'
        RawAlg.find(starred_id)
      when 'combo_alg'
        ComboAlg.find(starred_id)
      else
        raise "Unknown galaxy.starred_type '#{galaxy.starred_type}'"
    end
  end
end
