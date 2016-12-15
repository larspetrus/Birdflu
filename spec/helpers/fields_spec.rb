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
  end

    it 'values' do
      expect(Fields.values({})).to eq(OpenStruct.new(list: "positions", lines: "25", sortby: "_speed", algset: "0"))

      non_default_selections = {list: "algs", lines: "50", sortby: "length", algset: "101"}
      expect(Fields.values(non_default_selections)).to eq(OpenStruct.new(list: "algs", lines: "50", sortby: "length", algset: "101"))

      invalid_default_selections = {list: "invalid", lines: "invalid", sortby: "invalid", algset: "invalid"}
      expect(Fields.values(invalid_default_selections)).to eq(OpenStruct.new(list: "positions", lines: "25", sortby: "_speed", algset: "invalid"))
    end

  it '#defaults()' do
    size  = Fields::Select.new(:size,  %w(S M L XL))
    color = Fields::Select.new(:color, %w(Red Blue))

    expect(Fields.defaults([size, color])).to eq(size: 'S', color: 'Red')
  end

  it 'JS_DEFAULTS' do
    expect(Fields::JS_DEFAULTS).to eq('{list: "positions", lines: "25", sortby: "_speed", algset: "0"}')
  end

  it 'JQ_SELECTOR' do
    expect(Fields::JQ_SELECTOR).to eq("#list, #lines, #sortby, #algset")
  end

end
