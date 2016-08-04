class PosCodes

  def self.valid_for(field)
    @valid_codes ||= {}
    @valid_codes[field.to_sym] ||= _valid_codes(field)
  end

  def self._valid_codes(field)
    execute("select distinct #{field} from positions").values.flatten.sort
  end

  def self.ep_by_cp(cp)
    type = self.ep_type_by_cp(cp)
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

  def self.execute(sql)
    ActiveRecord::Base.connection.execute(sql)
  end
end