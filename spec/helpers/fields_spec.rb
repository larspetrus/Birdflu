require 'rails_helper'

RSpec.describe 'Fields' do


  before(:each) do
    allow(AlgSet).to receive(:predefined) {[double(name: 'abc', id: 11), double(name: 'xyz', id: 12)]}
  end

  describe 'Fields::Select' do
    let(:size) {Fields::Select.new(:size, %w(S M L XL))}
    let(:count){Fields::Select.new(:count, [1,2,3])}

    it 'value()' do
      expect(size.value(size: 'M')).to eq('M')
      expect(size.value(fall_back: 'on default')).to eq('S')
      expect(size.value(size: 'ALSO DEFAULT ->')).to eq('S')

      expect(count.value(count: '2')).to eq('2')
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
      expect(Fields.values({})).to eq(OpenStruct.new(list: "positions", lines: "25", sortby: "_speed", algset_id: "0"))

      params = {list: "algs", lines: "50", sortby: "length", algset_id: "11"}
      expect(Fields.values(params)).to eq(OpenStruct.new(list: "algs", lines: "50", sortby: "length", algset_id: "11"))
    end

  it '#defaults()' do
    size  = Fields::Select.new(:size,  %w(S M L XL))
    color = Fields::Select.new(:color, %w(Red Blue))

    expect(Fields.defaults([size, color])).to eq(size: 'S', color: 'Red')
  end

end
