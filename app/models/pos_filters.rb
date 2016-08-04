# frozen_string_literal: true

# PosFilters makes filters for the next page from the form post data.
class PosFilters

  BASE = [:co, :cp, :eo, :ep]
  DERIVED = [:cop, :oll]
  ALL = DERIVED + BASE

  attr_reader :all, :where, :reload

  def initialize(params)
    start_params = params[:pos] ? PosFilters.unpack_pos(params[:pos]) : params
    nf = {} # new filters
    start_params.each{|p,v| nf[p.to_sym] = v if BASE.include?(p.to_sym) && v.present? }

    changed, new_value = (params[:change] || ' - ').split('-')
    if new_value == 'random'
      @reload = true
      new_value = nf[changed.to_sym] = PosFilters.random_code(changed, nf)
    end

    # New start with COP
    if changed == 'cop'
      nf[:co] = nf[:cp] = nil
      if PosCodes.valid_for(:cop).include?(new_value)
        nf[:co], nf[:cp] = new_value.split('')
        nf[:eo] = nf[:ep] = ''
      end
    end

    # New start with OLL
    if changed == 'oll'
      nf[:co] = PosCodes.co_by_oll(new_value)
      nf[:eo] = PosCodes.eo_by_oll(new_value)

      nf[:cp] = nf[:ep] = '' if new_value.present?
    end

    # Did EP become incompatible?
    if changed == 'cp' && nf[:cp].present? && nf[:ep].present?
      ep_case = (nf[:ep] == nf[:ep].upcase()) ? :upper : :lower
      if PosCodes.ep_type_by_cp(nf[:cp]) != ep_case
        nf[:ep] = ''
      end
    end

    nf[:cop] = "#{nf[:co]}#{nf[:cp]}" if nf[:co].present? && nf[:cp].present?
    nf[:oll] = PosCodes.oll_by_co_eo(nf[:co], nf[:eo])
    ALL.each { |f| nf[f] ||= '' }

    @all = nf.freeze
    @where = @all.dup.select{|k,v| v.present? && (not [:cop, :oll].include?(k))}
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

  def self.unpack_pos(pos_string)
    result = {
      co: pos_string[0],
      cp: pos_string[1],
      eo: pos_string[2],
      ep: pos_string[3],
    }.with_indifferent_access

    BASE.each do |f|
      result[f] = '' unless PosCodes.valid_for(f).include?(result[f])
    end

    result
  end
end
