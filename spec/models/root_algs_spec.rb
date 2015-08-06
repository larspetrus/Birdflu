require 'rails_helper'

describe RootAlgs do

  it 'alg_symmetry' do
    expect(RootAlgs.unique_variants("F U F' U F U2 F'")).to            eq([:a, :Ma, :Aa, :AMa])
    expect(RootAlgs.unique_variants("L U' R' U L' U' R")).to           eq([:a, :Ma])
    expect(RootAlgs.unique_variants("R2 F2 B2 L2 D L2 B2 F2 R2")).to   eq([:a])
    expect(RootAlgs.unique_variants("B' U' R B' R' B2 U' B' U2 B")).to eq([:a, :Aa])
  end
end