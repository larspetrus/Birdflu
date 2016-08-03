# frozen_string_literal: true

class PosSubsets

  attr_reader :as_params, :where, :reload

  def initialize(params)
    start_params = params[:pos] ? PosSubsets.unpack_pos(params[:pos]) : params
    np = {} # new parameters
    Fields::FILTER_NAMES.each do |f|
      np[f] = start_params[f] if start_params[f]
    end

    changed, new_value = (params[:change] || ' - ').split('-')
    if new_value == 'random'
      @reload = true
      new_value = np[changed.to_sym] = PosSubsets.random_code(changed, np)
    end

    # New start with COP
    if changed == 'cop'
      np[:oll] = np[:co] = np[:cp] = ''
      if new_value.present?
        np[:cop] = new_value
        np[:eo] = np[:ep] = ''
        np[:co], np[:cp] = new_value.split('')
      end
    end

    # New start with OLL
    if changed == 'oll'
      np[:co] = np[:eo] = np[:cop] = ''
      if new_value.present?
        np[:oll] = new_value
        np[:cp] = np[:ep] = ''
        np[:eo] = PosSubsets.eo_by_oll(np[:oll])
        np[:co] = PosSubsets.co_by_oll(np[:oll])
      end
    end

    # Compute COP
    if changed == 'co' || changed == 'cp' || np[:cop].blank?
      has_value = np[:co].present? && np[:cp].present?
      np[:cop] =  has_value ? "#{np[:co]}#{np[:cp]}" : ""
    end

    # Compute OLL
    if changed == 'co' || changed == 'eo' || np[:oll].blank?
      np[:oll] = PosSubsets.oll_by_co_eo(np[:co], np[:eo]) || ''
    end

    # Did EP become incompatible?
    if changed == 'cp' && np[:cp].present? && np[:ep].present?
      ep_case = (np[:ep] == np[:ep].upcase()) ? :upper : :lower
      if PosSubsets.ep_type_by_cp(np[:cp]) != ep_case
        np[:ep] = ''
      end
    end

    @as_params = np
    @where = @as_params.dup.select{|k,v| v.present? && (not [:cop, :oll].include?(k))}
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
