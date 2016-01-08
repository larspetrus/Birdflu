class PosSubsets

  attr_reader :as_params, :where, :reload

  def initialize(params)
    @reload = params.values.include?('random')
    clicked = params[:clicked]

    np = {} # new parameters
    Fields::FILTER_NAMES.each do |f|
      if params[f]
        np[f] = (params[f] == 'random') ? PosSubsets.random_code(f, params) : params[f]
      end
    end

    # New start with COP
    if clicked == '#cop'
      np[:oll] = np[:co] = np[:cp] = ''
      if np[:cop].present?
        np[:eo] = np[:ep] = ''
        np[:co], np[:cp] = np[:cop].split('')
      end
    end

    # New start with OLL
    if clicked == '#oll'
      np[:co] = np[:eo] = np[:cop] = ''
      if np[:oll].present?
        np[:cp] = np[:ep] = ''
        np[:eo] = PosSubsets.eo_by_oll(np[:oll])
        np[:co] = PosSubsets.co_by_oll(np[:oll])
      end
    end

    # Compute new COP
    if clicked == '#co' || clicked == '#cp'
      has_value = np[:co].present? && np[:cp].present?
      np[:cop] =  has_value ? "#{np[:co]}#{np[:cp]}" : ""
    end

    # Compute new OLL
    if clicked == '#co' || clicked == '#eo'
      np[:oll] = PosSubsets.oll_by_co_eo(np[:co], np[:eo]) || ''
    end

    # Did EP become incompatible?
    if clicked == '#cp' && np[:cp].present? && np[:ep].present?
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

  def self.random_code(subset, contraints)
    case subset.to_sym
      when :cop, :oll
        Position.find(Position.random_id)[subset]
      when :co
        %w(A B b C D E F G).sample
      when :cp
        %w(o d b l r f).sample
      when :eo
        %w(0 1 2 4 6 7 8 9).sample
      when :ep
        self.ep_codes_by_cp(contraints[:cp]).sample
      else
        raise "Unknown position subset '#{subset}'"
    end
  end

  def self.ep_codes_by_cp(cp)
    type = self.ep_type_by_cp(cp.to_s)
    (type == :lower ? [] : Icons::Ep.upper_codes) + (type == :upper ? [] : Icons::Ep.lower_codes)
  end

  def self.co_by_oll(oll)
    @co_oll ||= {}.tap do |h|
      ActiveRecord::Base.connection.execute("select distinct oll, co from positions").each do |q|
        h[q['oll']] = q['co']
      end
    end
    @co_oll[oll.to_s]
  end

  def self.eo_by_oll(oll)
    @eo_oll ||= {}.tap do |h|
      ActiveRecord::Base.connection.execute("select distinct oll, eo from positions").each do |q|
        h[q['oll']] = q['eo']
      end
    end
    @eo_oll[oll.to_s]
  end

  def self.oll_by_co_eo(co, eo)
    @oll_co_eo ||= {}.tap do |h|
      ActiveRecord::Base.connection.execute("select distinct oll, co, eo from positions").each do |q|
        h[[q['co'], q['eo']]] = q['oll']
      end
    end
    @oll_co_eo[[co.to_s, eo.to_s]]
  end

  def self.ep_type_by_cp(cp)
    @ep_cop ||= {}.tap do |h|
      ActiveRecord::Base.connection.execute("select distinct cp, ep from positions").each do |q|
        ep = q['ep']
        h[q['cp']] = (ep == ep.upcase()) ? :upper : :lower
      end
    end
    @ep_cop[cp.to_s] || :both
  end
end
