# frozen_string_literal: true

# PosFilters makes filters for the next page from the form post data.
class PosFilters

  BASE = [:co, :cp, :eo, :ep]
  DERIVED = [:cop, :oll]
  ALL = DERIVED + BASE

  attr_reader :all, :where

  def initialize(params, position_set)
    filters = PosFilters.unpack_pos(params[:pos])
    from_url = params[:poschange].nil? # From a URL, possibly manually typed

    changed, new_value = (params[:poschange] || ' - ').split('-')

    if ALL.include?(changed.to_sym)
      new_value = PosFilters.random_code(changed, filters, position_set) if new_value == 'random'
      filters[changed.to_sym] = new_value
    end

    # New start with COP
    if changed == 'cop'
      filters[:co] = filters[:cp] = nil
      if PosCodes.valid_for(:cop).include?(new_value)
        filters[:co], filters[:cp] = new_value.split('')
        filters[:eo] = ''
        filters[:ep] = ''
      end
    end

    # New start with OLL
    if changed == 'oll'
      filters[:co] = PosCodes.co_by_oll(new_value)
      filters[:eo] = PosCodes.eo_by_oll(new_value)

      filters[:cp] = filters[:ep] = '' if new_value.present?
    end

    # Did EP become incompatible?
    if (changed == 'cp' || from_url) && filters[:cp].present? && filters[:ep].present?
      ep_case = (('A'..'Z').include? filters[:ep]) ? :upper : :lower
      filters[:ep] = '' unless PosCodes.ep_type_by_cp(filters[:cp]) == ep_case
    end

    filters[:eo] = '4' if position_set == 'eo' && filters[:eo].blank?
    filters[:cop] = "#{filters[:co]}#{filters[:cp]}" if filters[:co].present? && filters[:cp].present?
    filters[:oll] = PosCodes.oll_by_co_eo(filters[:co], filters[:eo])
    ALL.each { |f| filters[f] ||= '' }

    @all = filters.freeze
    @where = @all.dup.select{|k,v| v.present? && (not [:cop, :oll].include?(k))}
  end

  def self.unpack_pos(pos)
    sanitized_pos = (pos || '').ljust(4, ' ')
    sanitized_pos[0] = sanitized_pos[0].upcase unless sanitized_pos[0] == 'b'
    sanitized_pos[1] = sanitized_pos[1].downcase

    {}.tap do |result|
      BASE.each_with_index do |filter, i|
        code = sanitized_pos[i]
        result[filter] = code if PosCodes.valid_for(filter).include?(code)
      end
    end
  end

  def pos_code
    BASE.map{|f| @where[f] || '_'}.join
  end

  def [](key)
    @all[key.to_sym]
  end

  def count
    @where.keys.count
  end

  def self.random_code(filter_prop, constraints, position_set)
    case filter_prop.to_sym
      when :cop, :oll
        Position.find(Position.random_id(position_set))[filter_prop] # Gives natural distribution (ignoring weight)
      when :co, :cp, :eo
        PosCodes.valid_for(filter_prop).sample
      when :ep
        PosCodes.ep_by_cp(constraints[:cp]).sample
      else
        raise "Unknown position filter '#{filter_prop}'"
    end
  end
end
