class PosSubsets

  def self.selected_subsets(params)
    ss = {}
    PositionsController::POSITION_FILTERS.each do |f|
      if params[f]
        ss[f] = (params[f] == 'random') ? self.random_code(f, params) : params[f]
      end
    end

    clicked = params[:clicked]

    if clicked == '#cop'
      ss[:oll] = ss[:eo] = ss[:ep] = ''
      ss[:co], ss[:cp] = ss[:cop].split('')
    end

    if clicked == '#oll'
      ss[:cop] = ss[:cp] = ss[:ep] = ''
      ss[:eo] = self.eo_by_oll(ss[:oll])
      ss[:co] = self.co_by_oll(ss[:oll])
    end

    if clicked == '#co' || clicked == '#cp'
      if ss[:co].present? && ss[:cp].present?
        ss[:cop] = "#{ss[:co]}#{ss[:cp]}"

        case ss[:cop] # ugh...
          when 'Ab', 'Al', 'Ar'
            ss[:cop] = 'Af'
            ss[:cp] = 'f'
          when 'Fb'
            ss[:cop] = 'Ff'
            ss[:cp] = 'f'
          when 'Fr'
            ss[:cop] = 'Fl'
            ss[:cp] = 'l'
        end
      end
    end

    if clicked == '#co' || clicked == '#eo'
      if ss[:co].present? && ss[:eo].present?
        ss[:oll] = self.oll_by_co_eo(ss[:co], ss[:eo])
      end
    end

    ss
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
