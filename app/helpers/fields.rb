# frozen_string_literal: true

# The dropdown fields of the #main-form
class Fields

  class Select
    attr_reader :name, :default

    def initialize(name, options)
      @name = name
      @options = options
      @values = @options.map{|opt| [opt].flatten.last.to_s}
      @default = @values.first
    end

    def value(parameters)
      @values.include?(parameters[@name]) ? parameters[@name] : @default
    end

    def as_tag(parameters, options = {})
      hlp.select_tag(@name, hlp.options_for_select(@options, selected: value(parameters)), options)
    end

    def as_css_id
      "##{@name}"
    end

    def hlp
      ActionController::Base.helpers
    end
  end

  LIST   = Select.new(:list,  ['positions', 'algs'])
  LINES  = Select.new(:lines, [25, 50, 100, 200, 500])
  SORTBY = Select.new(:sortby,[['speed', '_speed'], ['moves', 'length']])
  ALGSET = Select.new(:algset,[['None', 0]] + AlgSet.menu_options)

  ALL = [LIST, LINES, SORTBY, ALGSET].freeze

  COOKIE_NAME = :field_values

  def self.values(params)
    value_hash = {}
    ALL.each { |format| value_hash[format.name] = format.value(params) }
    OpenStruct.new(value_hash)
  end

  def self.defaults(fields)
    {}.tap { |result| fields.each { |f| result[f.name] = f.default } }
  end

  JS_DEFAULTS = Fields.defaults(Fields::ALL).to_s.gsub(':', '').gsub('=>', ': ').freeze
  JQ_SELECTOR = Fields::ALL.map{|f| f.as_css_id}.join(', ').freeze

  ALL_DEFAULTS = Fields.defaults(Fields::ALL).freeze

end