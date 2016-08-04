# frozen_string_literal: true

# PosFilters makes filters for the next page from the form post data.
class PosFilters

  BASE = [:co, :cp, :eo, :ep]
  DERIVED = [:cop, :oll]
  ALL = DERIVED + BASE

  attr_reader :all, :where, :reload

  def initialize(params)
    filters = PosFilters.unpack_pos(params[:pos])

    changed, new_value = (params[:change] || ' - ').split('-')
    if ALL.include?(changed.to_sym)
      if new_value == 'random'
        @reload = true
        new_value = PosFilters.random_code(changed, filters)
      end
      filters[changed.to_sym] = new_value
    end

    # New start with COP
    if changed == 'cop'
      filters[:co] = filters[:cp] = nil
      if PosCodes.valid_for(:cop).include?(new_value)
        filters[:co], filters[:cp] = new_value.split('')
        filters[:eo] = filters[:ep] = ''
      end
    end

    # New start with OLL
    if changed == 'oll'
      filters[:co] = PosCodes.co_by_oll(new_value)
      filters[:eo] = PosCodes.eo_by_oll(new_value)

      filters[:cp] = filters[:ep] = '' if new_value.present?
    end

    # Did EP become incompatible?
    if changed == 'cp' && filters[:cp].present? && filters[:ep].present?
      ep_case = (('A'..'Z').include? filters[:ep]) ? :upper : :lower
      filters[:ep] = '' unless PosCodes.ep_type_by_cp(filters[:cp]) == ep_case
    end

    filters[:cop] = "#{filters[:co]}#{filters[:cp]}" if filters[:co].present? && filters[:cp].present?
    filters[:oll] = PosCodes.oll_by_co_eo(filters[:co], filters[:eo])
    ALL.each { |f| filters[f] ||= '' }

    @all = filters.freeze
    @where = @all.dup.select{|k,v| v.present? && (not [:cop, :oll].include?(k))}
  end

  def self.unpack_pos(pos)
    return {} unless pos
    result = {}
    BASE.each_with_index do |code, i|
      result[code] = pos[i] if PosCodes.valid_for(code).include?(pos[i])
    end
    result
  end

  def url
    @url ||= @where.keys.map{|k| "#{k}=#{@where[k]}"}.join('&')
  end

  def pos_code
    BASE.map{|f| @where[f] || '_'}.join
  end

  def [](key)
    @all[key.to_sym]
  end

  def all_set
    @where.keys.sort == BASE
  end

  def self.random_code(subset, constraints)
    case subset.to_sym
      when :cop, :oll
        Position.find(Position.random_id)[subset] # Gives natural distribution (ignoring weight)
      when :co, :cp, :eo
        PosCodes.valid_for(subset).sample
      when :ep
        PosCodes.ep_by_cp(constraints[:cp]).sample
      else
        raise "Unknown position subset '#{subset}'"
    end
  end
end
