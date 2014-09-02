require 'rails_helper'

RSpec.describe LlAlg, :type => :model do
  it 'verifies F2L is preserved' do
    expect{LlAlg.new("Not a LL alg!", "F U D")}.to raise_error
  end

  it 'computes LL code' do
    sune = LlAlg.new("Sune", "F U F' U F U2 F'")
    expect(sune.solves_ll_code).to eq('a1c3c3c5')
  end
end
