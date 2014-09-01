require 'rails_helper'

RSpec.describe LlAlg, :type => :model do
  it 'makes all variants' do
    stigs = LlAlg.variants('Nik', "L U' R' U L' U' R")

    expect(stigs.map(&:moves)).to eq(["L U' R' U L' U' R", "B U' F' U B' U' F", "R U' L' U R' U' L", "F U' B' U F' U' B"])
    expect(stigs.map(&:name)).to eq(['Nik-L', 'Nik-B', 'Nik-R', 'Nik-F'])
  end

  it 'verifies F2L is preserved' do
    expect{LlAlg.new("Not a LL alg!", "F U D")}.to raise_error
  end

  it 'computes LL code' do
    sune = LlAlg.new("Sune", "F U F' U F U2 F'")
    expect(sune.solves_ll_code).to eq('a1c3c3c5')
  end
end
