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

    def as_tag(parameters)
      hlp.select_tag(@name, hlp.options_for_select(@options, selected: value(parameters)))
    end

    def as_css_id
      "##{@name}"
    end
  end

  LIST   = Select.new(:list,  ['positions', 'algs'])
  LINES  = Select.new(:lines, [25, 50, 100, 200, 500])
  SORTBY = Select.new(:sortby,[['speed', '_speed'], ['moves', 'length']])
  ALGSET = Select.new(:algset,[['All', 0]] + AlgSet.predefined.map{|as| [as.name, as.id] })

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

  ALL_DEFAULTS = Fields.defaults(Fields::ALL).freeze

end