require 'rails_helper'

RSpec.describe LlCode do
  it 'versions' do
    expect(LlCode.new('a1c5e1p5').variants).to eq(["a1c5e1p5", "c5e1p5a1", "a7j3o7q3", "b7e3g7i3"])
  end

  it 'mirror' do
    expect(LlCode.new('a7g3o6b6').mirror).to eq('a5j1o4q4')
    expect(LlCode.new('a5j1o4q4').mirror).to eq('a8f8e1k5')
  end

  it 'oll_code' do
    expect(LlCode.new('a8j1b2j3').oll_code).to eq(:a2b1b2b1)
    expect(LlCode.new('b7f2g6k7').oll_code).to eq(:b1b2c2c1)
    expect(LlCode.new('a2e5g8j7').oll_code).to eq(:a1c2b1a2)
  end

  it 'cop_code' do
    expect(LlCode.new('a8j1b2j3').cop_code).to eq(:ajbj)
    expect(LlCode.new('b7f2g6k7').cop_code).to eq(:bfgk)
    expect(LlCode.new('a2e5g8j7').cop_code).to eq(:aegj)
  end

  it 'eo_code' do
    expect(LlCode.new('a8j1b2j3').eo_code).to eq('2121')
    expect(LlCode.new('b7f2g6k7').eo_code).to eq('1221')
    expect(LlCode.new('a2e5g8j7').eo_code).to eq('2121')
  end

  it 'ep_code' do
    expect(LlCode.new('a8j1b2j3').ep_code).to eq('7113')
    expect(LlCode.new('b7f2g6k7').ep_code).to eq('7157')
    expect(LlCode.new('a2e5g8j7').ep_code).to eq('1577')
  end

  it '#official_sort' do
    expect(LlCode.official_sort('a8j1b2j3')).to eq('abbbajbj21218123')
    expect(LlCode.official_sort('b7f2g6k7')).to eq('bbccbfgk12217267')
  end
end
