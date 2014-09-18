require 'rails_helper'

describe BigThought do

  it 'makes all alg variants' do
    stigs = BigThought.alg_variants('Nik', "L U' R' U L' U' R")

    expect(stigs.map(&:moves)).to eq(["L U' R' U L' U' R", "R' U L U' R U L'", "B U' F' U B' U' F", "F' U B U' F U B'", "R U' L' U R' U' L", "L' U R U' L U R'", "F U' B' U F' U' B", "B' U F U' B U F'"])
    expect(stigs.map(&:name)).to eq(["Nik", "NikM", "Nik", "NikM", "Nik", "NikM", "Nik", "NikM"])
    expect(stigs.map(&:kind)).to eq(['solve', 'solve', 'generator', 'generator', 'generator', 'generator', 'generator', 'generator'])
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

  it 'reverse' do
    expect(BigThought.reverse("F U' B2 D")).to eq("D' B2 U F'")
    expect(BigThought.reverse("R L' R2")).to eq("R2 L R'")
    expect(BigThought.reverse("B L' B R2 B' L B R2 B2")).to eq("B2 R2 B' L' B R2 B' L B'")
  end

  it 'root_algs' do
    puts BigThought.root_algs.pretty_inspect

    #TODO
    # 1. Determine which base algs should be reversed
    # 2. Should all be mirrored?
    # 3. Find dupes

  end
end