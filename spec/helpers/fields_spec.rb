require 'rails_helper'

RSpec.describe Fields, :type => :model do

  describe Fields::Select do
    let(:size) {Fields::Select.new(:size, %w(S M L XL))}

    it 'value()' do
      expect(size.value(size: 'M')).to eq('M')
      expect(size.value(fall_back: 'on default')).to eq('S')
    end

    it 'default' do
      expect(size.default).to eq('S')
    end

    it 'as_tag()' do
      expect(size.as_tag(size:'XL')).to eq("<select id=\"size\" name=\"size\"><option value=\"S\">S</option>\n<option value=\"M\">M</option>\n<option value=\"L\">L</option>\n<option selected=\"selected\" value=\"XL\">XL</option></select>")
    end

    it 'as_css_id()' do
      expect(size.as_css_id).to eq('#size')
    end
  end

  it '#defaults()' do
    size  = Fields::Select.new(:size,  %w(S M L XL))
    color = Fields::Select.new(:color, %w(Red Blue))

    expect(Fields.defaults([size, color])).to eq(size: 'S', color: 'Red')
  end

end
