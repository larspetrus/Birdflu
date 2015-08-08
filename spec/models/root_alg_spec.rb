require 'rails_helper'

describe RootAlg do

  it 'alg_symmetry' do
    expect(RootAlg.new('-', "F U F' U F U2 F'").alg_variants).to            eq([:a, :Ma, :Aa, :AMa])
    expect(RootAlg.new('-', "L U' R' U L' U' R").alg_variants).to           eq([:a, :Ma])
    expect(RootAlg.new('-', "R2 F2 B2 L2 D L2 B2 F2 R2").alg_variants).to   eq([:a])
    expect(RootAlg.new('-', "B' U' R B' R' B2 U' B' U2 B").alg_variants).to eq([:a, :Aa])
  end

  it 'names are unique' do
    expect(RootAlg.all.size).to eq(RootAlg.all.map(&:name).uniq.size)
  end
end