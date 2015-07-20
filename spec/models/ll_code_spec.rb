require 'rails_helper'

RSpec.describe LlCode do
  it 'versions' do
    expect(LlCode.new('a1c5e1p5').variants).to eq(["a1c5e1p5", "c5e1p5a1", "a7j3o7q3", "b7e3g7i3"])
  end

  it 'mirror' do
    expect(LlCode.new('a7g3o6b6').mirror).to eq('a5j1o4q4')
    expect(LlCode.new('a5j1o4q4').mirror).to eq('a7g3o6b6')
  end

  it 'standardize' do
    expect(LlCode.new('c5e1p5a1').standardize).to eq("a1c5e1p5")
  end

  it 'cop_code' do
    expect(LlCode.new('a8j1b2j3').cop_code).to eq(:ajbj)
    expect(LlCode.new('b7f2g6k7').cop_code).to eq(:bcgp)
    expect(LlCode.new('a2e5g8j7').cop_code).to eq(:acfo)
  end

  it 'oll_code' do
    expect(LlCode.new('a8j1b2j3').oll_code).to eq(:a2b1b2b1)
    expect(LlCode.new('b7f2g6k7').oll_code).to eq(:b1b2c2c1)
    expect(LlCode.new('a2e5g8j7').oll_code).to eq(:a1c2b1a2)
  end
end
