require 'rails_helper'

RSpec.describe Icons::Big do

  it 'css_classes' do
    big_icon = Icons::Big.new(Position.find(666))
    expect(big_icon.css_classes('xyz', false)).to eq('illustration-icon')
  end
end