# frozen_string_literal: true

# PosFilters makes filters for the next page from the form post data.
class PosFilters

  attr_reader :all, :where, :reload

  def initialize(params)
    start_params = params[:pos] ? PosFilters.unpack_pos(params[:pos]) : params
    nf = {} # new filters
    Fields::FILTER_NAMES.each do |f|
      nf[f] = start_params[f] if start_params[f]
    end

    changed, new_value = (params[:change] || ' - ').split('-')
    if new_value == 'random'
      @reload = true
      new_value = nf[changed.to_sym] = PosFilters.random_code(changed, nf)
    end

    # New start with COP
    if changed == 'cop'
      nf[:oll] = nf[:co] = nf[:cp] = ''
      if new_value.present?
        nf[:cop] = new_value
        nf[:eo] = nf[:ep] = ''
        nf[:co], nf[:cp] = new_value.split('')
      end
    end

    # New start with OLL
    if changed == 'oll'
      nf[:co] = nf[:eo] = nf[:cop] = ''
      if new_value.present?
        nf[:oll] = new_value
        nf[:cp] = nf[:ep] = ''
        nf[:eo] = PosFilters.eo_by_oll(nf[:oll])
        nf[:co] = PosFilters.co_by_oll(nf[:oll])
      end
    end

    # Compute COP
    if changed == 'co' || changed == 'cp' || nf[:cop].blank?
      has_value = nf[:co].present? && nf[:cp].present?
      nf[:cop] =  has_value ? "#{nf[:co]}#{nf[:cp]}" : ""
    end

    # Compute OLL
    if changed == 'co' || changed == 'eo' || nf[:oll].blank?
      nf[:oll] = PosFilters.oll_by_co_eo(nf[:co], nf[:eo]) || ''
    end

    # Did EP become incompatible?
    if changed == 'cp' && nf[:cp].present? && nf[:ep].present?
      ep_case = (nf[:ep] == nf[:ep].upcase()) ? :upper : :lower
      if PosFilters.ep_type_by_cp(nf[:cp]) != ep_case
        nf[:ep] = ''
      end
    end

    @all = nf.freeze
    @where = @all.dup.select{|k,v| v.present? && (not [:cop, :oll].include?(k))}
  end

  def url
    @url ||= @where.keys.map{|k| "#{k}=#{@where[k]}"}.join('&')
  end

  def pos_code
    [:co, :cp, :eo, :ep].map{ |f|  @where[f] || '_'}.join
  end

  def [](key)
    @all[key.to_sym]
  end

  def fully_defined
    @where.keys.sort == [:co, :cp, :eo, :ep]
  end

  def self.random_code(subset, constraints)
    case subset.to_sym
      when :cop, :oll
        Position.find(Position.random_id)[subset] # Gives natural distribution (ignoring weight)
      when :co, :cp, :eo
        valid_codes(subset).sample
      when :ep
        self.ep_codes_by_cp(constraints[:cp]).sample
      else
        raise "Unknown position subset '#{subset}'"
    end
  end

  def self.valid_codes(field)
    @valid_codes ||= {}
    @valid_codes[field.to_sym] ||= _valid_codes(field)
  end

  def self._valid_codes(field)
    execute("select distinct #{field} from positions").values.flatten.sort
  end

  def self.ep_codes_by_cp(cp)
    type = self.ep_type_by_cp(cp.to_s)
    (type == :lower ? [] : Icons::Ep.upper_codes) + (type == :upper ? [] : Icons::Ep.lower_codes)
  end

  def self.co_by_oll(oll)
    @co_oll ||= {}.tap do |h|
      execute("select distinct oll, co from positions").each do |q|
        h[q['oll']] = q['co']
      end
    end
    @co_oll[oll.to_s]
  end

  def self.eo_by_oll(oll)
    @eo_oll ||= {}.tap do |h|
      execute("select distinct oll, eo from positions").each do |q|
        h[q['oll']] = q['eo']
      end
    end
    @eo_oll[oll.to_s]
  end

  def self.oll_by_co_eo(co, eo)
    @oll_co_eo ||= {}.tap do |h|
      execute("select distinct oll, co, eo from positions").each do |q|
        h[[q['co'], q['eo']]] = q['oll']
      end
    end
    @oll_co_eo[[co.to_s, eo.to_s]]
  end

  def self.ep_type_by_cp(cp)
    @ep_cop ||= {}.tap do |h|
      execute("select distinct cp, ep from positions").each do |q|
        ep = q['ep']
        h[q['cp']] = (ep == ep.upcase()) ? :upper : :lower
      end
    end
    @ep_cop[cp.to_s] || :both
  end

  def self.unpack_pos(pos_string)
    result = {
      co: pos_string[0],
      cp: pos_string[1],
      eo: pos_string[2],
      ep: pos_string[3],
    }

    [:co, :cp, :eo, :ep].each do |f|
      result[f] = '' unless valid_codes(f).include?(result[f])
    end

    result
  end

  def self.execute(sql)
    ActiveRecord::Base.connection.execute(sql)
  end
end
