require 'rails_helper'

describe BigThought do

  it 'makes all alg variants' do
    stigs = BigThought.alg_variants('Nik', "L U' R' U L' U' R")

    expect(stigs.map(&:moves)).to eq(["L U' R' U L' U' R", "R' U L U' R U L'", "B U' F' U B' U' F", "F' U B U' F U B'", "R U' L' U R' U' L", "L' U R U' L U R'", "F U' B' U F' U' B", "B' U F U' B U F'"])
    expect(stigs.map(&:name)).to eq(["Nik-L", "NikM-R'", "Nik-B", "NikM-F'", "Nik-R", "NikM-L'", "Nik-F", "NikM-B'"])
    expect(stigs.map(&:primary)).to eq([true, true, false, false, false, false, false, false])
  end

  it 'alg_label' do
    expect(BigThought.alg_label("F U F'")).to eq("F")
    expect(BigThought.alg_label("F2 U F'")).to eq("F2U")
    expect(BigThought.alg_label("F2 U2 F'")).to eq("F2U2F'")
  end

  it 'mirror' do
    expect(BigThought.mirror("F U' B2 D")).to eq("F' U B2 D'")
    expect(BigThought.mirror("R L' R2")).to eq("L' R L2")
    expect(BigThought.mirror("B L' B R2 B' L B R2 B2")).to eq("B' R B' L2 B R' B' L2 B2")
  end
end