# frozen_string_literal: true

# The dropdown fields of the #main-form
class Fields

  class Select
    attr_reader :name, :default

    def initialize(name, choices, any_values = false)
      @name = name
      @choices = choices
      @values = @choices.map{|opt| [opt].flatten.last.to_s}
      @default = @values.first
      @any_values = any_values
    end

    def value(selections)
      (@values.include?(selections[@name]) || @any_values) ? (selections[@name] || @default) : @default
    end

    def as_tag(selections, extra_choices = [], html_options = {})
      options = hlp.options_for_select(@choices + extra_choices, selected: value(selections))
      hlp.select_tag(@name, options, html_options)
    end

    def as_hidden_field(selections)
      hlp.hidden_field_tag(@name, value(selections), form: 'main-form')
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
  ALGSET = Select.new(:algset,[['None', 0]], true)
  COMBOS = Select.new(:combos,[['No Combos', 'none'], ['Merge Combos', 'merge'], ['Only Combos', 'only']])

  ALL = [LIST, LINES, SORTBY, ALGSET, COMBOS].freeze

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
  JQUERY_SELECTOR = Fields::ALL.map{|f| f.as_css_id}.join(', ').freeze

  ALL_DEFAULTS = Fields.defaults(Fields::ALL).freeze

end