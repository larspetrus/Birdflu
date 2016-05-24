class Fields

  class Select
    attr_reader :name, :default

    def initialize(name, options)
      @name = name
      @options = options
      @values = @options.map{|opt| [opt].flatten.last}
      @default = @values.first
    end

    def value(parameters)
      parameters[@name] || @default
    end

    def as_tag(parameters)
      h = ActionController::Base.helpers
      h.select_tag(@name, h.options_for_select(@options, selected: value(parameters)))
    end

    def as_css_id
      "##{@name}"
    end
  end

  FILTER_NAMES = [:cop, :oll, :co, :cp, :eo, :ep]

  LIST   = Select.new(:list,  ['positions', 'algs'])
  LINES  = Select.new(:lines, [25, 50, 100, 200, 500])
  SORTBY = Select.new(:sortby,[['speed', '_speed'], ['moves', 'length']])

  FORMATS = [LIST, LINES, SORTBY]

  def self.defaults(fields)
    {}.tap do |result|
      fields.each { |f| result[f.name] = f.default }
    end
  end

end