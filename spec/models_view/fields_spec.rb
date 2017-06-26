require 'rails_helper'

RSpec.describe 'Fields' do

  describe 'Fields::Select' do
    let(:size) {Fields::Select.new(:size, %w(S M L XL))}
    let(:count){Fields::Select.new(:count, [1,2,3], true)}

    it 'value()' do
      expect(size.value(size: 'M')).to eq('M')
      expect(size.value(fall_back: 'on default')).to eq('S')
      expect(size.value(size: 'ALSO DEFAULT ->')).to eq('S')

      expect(count.value(count: '2')).to eq('2')
      expect(count.value(fall_back: 'on default')).to eq('1')
      expect(count.value(count: '14')).to eq('14')
    end

    it 'default' do
      expect(size.default).to eq('S')
      expect(count.default).to eq('1')
    end

    it 'as_css_id()' do
      expect(size.as_css_id).to eq('#size')
    end

    it 'as_hidden_field' do
      expect(size.as_hidden_field({size: 'M'})).to eq('<input type="hidden" name="size" id="size" value="M" form="main-form" />')
    end
  end

    it 'values' do
      expect(Fields.values({})).to eq(OpenStruct.new(list: "positions", lines: "25", sortby: "_speed", algset: "0", combos: "none"))

      non_default_selections = {list: "algs", lines: "50", sortby: "length", algset: "101", combos: 'only'}
      expect(Fields.values(non_default_selections)).to eq(OpenStruct.new(list: "algs", lines: "50", sortby: "length", algset: "101", combos: 'only'))

      invalid_default_selections = {list: "invalid", lines: "invalid", sortby: "invalid", algset: "invalid", combos: "invalid"}
      expect(Fields.values(invalid_default_selections)).to eq(OpenStruct.new(list: "positions", lines: "25", sortby: "_speed", algset: "invalid", combos: "none"))
    end

  it '#defaults()' do
    size  = Fields::Select.new(:size,  %w(S M L XL))
    color = Fields::Select.new(:color, %w(Red Blue))

    expect(Fields.defaults([size, color])).to eq(size: 'S', color: 'Red')
  end

  it 'JS_DEFAULTS' do
    expect(Fields::JS_DEFAULTS).to eq('{list: "positions", lines: "25", sortby: "_speed", algset: "0", combos: "none"}')
  end

  it 'JQUERY_SELECTOR' do
    expect(Fields::JQUERY_SELECTOR).to eq("#list, #lines, #sortby, #algset, #combos")
  end


  describe 'Cookies' do
    it 'read_list_format' do
      missing_cookie = {}
      expect(Fields.read_list_format(missing_cookie).to_h).to eq(Fields::ALL_DEFAULTS)

      invalid_cookie = {field_values: ''}
      expect(Fields.read_list_format(invalid_cookie).to_h).to eq(Fields::ALL_DEFAULTS)

      fully_defined = {field_values: JSON.generate(list: "algs", lines: "100", sortby: "length", algset: "101")}
      expect(Fields.read_list_format(fully_defined).to_h)
          .to eq(:list=>"algs", :lines=>"100", :sortby=>"length", :algset=>"101", combos: "none")

      partially_defined = {field_values: JSON.generate(algset: "101")}
      expect(Fields.read_list_format(partially_defined).to_h)
          .to eq(:list=>"positions", :lines=>"25", :sortby=>"_speed", :algset=>"101", combos: "none")

      unknown_property = {field_values: JSON.generate(algset: "102", extra_key: 'Sparta!')}
      expect(Fields.read_list_format(unknown_property).to_h)
          .to eq(:list=>"positions", :lines=>"25", :sortby=>"_speed", :algset=>"102", combos: "none")

      invalid_value = {field_values: JSON.generate(lines: "37")}
      expect(Fields.read_list_format(invalid_value).to_h)
          .to eq(list: "positions", lines: "25", sortby: "_speed", algset: "0", combos: "none")
    end

    def mockies
      def (mock_cookies = {}).permanent; self end # add a "permanent" function to the hash
      mock_cookies
    end

    it 'store_list_format' do
      Fields.store_list_format(cookies = mockies, {lines: '50', algset: '101'}.with_indifferent_access)
      expect(cookies[:field_values]).to eq(JSON.generate(lines: '50', algset: '101'))

      Fields.store_list_format(cookies = mockies, {'lines' => '50', 'algset' => '101'}.with_indifferent_access)
      expect(cookies[:field_values]).to eq(JSON.generate(lines: '50', algset: '101'))

      Fields.store_list_format(cookies = mockies, {lines: '25', algset: '102', extra_key: 'Mango'}.with_indifferent_access)
      expect(cookies[:field_values]).to eq(JSON.generate(lines: '25', algset: '102'))
    end

    it 'update_list_format' do
      non_default_selections = {list: "algs", lines: "50", sortby: "length", algset: "101", combos: 'only'}.with_indifferent_access
      Fields.store_list_format(cookies = mockies, non_default_selections)

      Fields.update_list_format(cookies, {algset: "1729" })
      expect(cookies[:field_values]).to eq(JSON.generate(list: "algs", lines: "50", sortby: "length", algset: "1729", combos: 'only'))

      Fields.update_list_format(cookies, {combos: "merge", hacker_prop: ";DELETE * FROM raw_algs;" })
      expect(cookies[:field_values]).to eq(JSON.generate(list: "algs", lines: "50", sortby: "length", algset: "1729", combos: 'merge'))

      Fields.update_list_format(cookies, {lines: "347"})
      expect(cookies[:field_values]).to eq(JSON.generate(list: "algs", lines: "25", sortby: "length", algset: "1729", combos: 'merge'))
    end
  end
end
