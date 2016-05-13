require 'rails_helper'

RSpec.describe Algs do

  it 'mirror' do
    expect(Algs.mirror("F U' B2 D")).to eq("F' U B2 D'")
    expect(Algs.mirror("R L' U2")).to eq("L' R U2")
    expect(Algs.mirror("B L' B R2 B' L B R2 B2")).to eq("B' R B' L2 B R' B' L2 B2")
    expect(Algs.mirror("F B")).to eq("B' F'")    # normalize
  end

  it 'reverse' do
    expect(Algs.reverse("F U' B2 D")).to eq("D' B2 U F'")
    expect(Algs.reverse("R L' U2")).to eq("U2 L R'")
    expect(Algs.reverse("B L' B R2 B' L B R2 B2")).to eq("B2 R2 B' L' B R2 B' L B'")
    expect(Algs.reverse("B F")).to eq("B' F'")    # normalize
  end

  it '#rotate_by_U' do
    expect(Algs.rotate_by_U("F U2 R' D B2 L'")).to eq("L U2 F' D R2 B'")
    expect(Algs.rotate_by_U("B F", 2)).to eq("B F")    # normalize
  end

  it 'll_code_variant' do
    std_G1 = "B L F' L F L2 B'"
    expect(Algs.ll_code_variant(std_G1)).to eq(std_G1)
    expect(Algs.ll_code_variant(Algs.rotate_by_U(std_G1, 1))).to eq(std_G1)
    expect(Algs.ll_code_variant(Algs.rotate_by_U(std_G1, 2))).to eq(std_G1)
    expect(Algs.ll_code_variant(Algs.rotate_by_U(std_G1, 3))).to eq(std_G1)

    std_I143 = "F2 U L R' F2 L' R U F2"
    expect(Algs.ll_code_variant(std_I143)).to eq(std_I143)
    expect(Algs.ll_code_variant(Algs.rotate_by_U(std_I143, 1))).to eq(std_I143)
    expect(Algs.ll_code_variant(Algs.rotate_by_U(std_I143, 2))).to eq(std_I143)
    expect(Algs.ll_code_variant(Algs.rotate_by_U(std_I143, 3))).to eq(std_I143)
  end

  it 'normalize' do
    expect(Algs.normalize("F R2 L2 U D' B F2")).to eq("F L2 R2 D' U B F2")
    expect(Algs.normalize("B L' R F D2 U F B' R")).to eq("B L' R F D2 U B' F R")
  end

  it 'anti_normalize' do
    expect(Algs.anti_normalize("F R2 L2 U D' B F2")).to eq("F R2 L2 U D' F2 B")
    expect(Algs.anti_normalize("B L' R F D2 U F B' R")).to eq("B R L' F U D2 F B' R")
  end
  
  it 'equivalent_versions' do
    expect(Algs.equivalent_versions("F B' U").sort).to eq(["B' F U", "F B' U"])
    expect(Algs.equivalent_versions("D L2 R F B'").sort).to eq([ "D L2 R B' F", "D L2 R F B'", "D R L2 B' F", "D R L2 F B'"])
  end

  it 'compress' do
    expect(Algs.compress("F R2 L2 U D' B F2")).to eq('FrlUpBf')
    expect(Algs.compress("B F2 U' L F2 L' R U2 R' U B' F2")).to eq('BfnLf1RuPUqf')

    expect{Algs.compress('incorrect')}.to raise_error(RuntimeError)
  end

  it 'expand' do
    expect(Algs.expand('FrlUpBf')).to eq("F R2 L2 U D' B F2")
    expect(Algs.expand('BfnLf1RuPUqf')).to eq("B F2 U' L F2 L' R U2 R' U B' F2")

    expect{Algs.expand('incorrect')}.to raise_error(RuntimeError)
  end

  it 'from_tr' do
    expect(Algs.from_tr('F+U+F1L+F+L1U+L+')).to eq("F U F2 L F L2 U L")
    expect(Algs.from_tr('F+U-B-U+F-U-B+')).to eq("F U' B' U F' U' B")
  end

  it 'sides' do
    expect(Algs.sides("F U2 F'")).to eq('FU')
    expect(Algs.sides("F U' B' U F' U' B")).to eq('BFU')
  end

  it 'specialness' do
    expect(Algs.specialness("F U F' U F U2 F'")).to eq('FU')
    expect(Algs.specialness("B U2 B' U' B U' B'")).to eq('FU')
    expect(Algs.specialness("F U' B' U F' U' B")).to eq('FUB')
    expect(Algs.specialness("L U L D L' U' L D' L2")).to eq('UFD')
    expect(Algs.specialness("R2 D' L D R D' L' D R")).to eq('FDB')
    expect(Algs.specialness("L U F U' F' L'")).to eq('RFU')
    expect(Algs.specialness("F R2 D R D2 F D F2 R")).to eq('RFD')
    expect(Algs.specialness("L' B' R' U R U2 B U L")).to eq(nil)
    expect(Algs.specialness("")).to eq(nil)
  end

  it 'speed_score is symmetrical' do
    alg = "D2 F' U2 B' D2 B2 F' L2 F L2 R2 B' F' R2 F2"
    a0, a1, a2, a3  = [0,1,2,3].map{|i| Algs.rotate_by_U(alg, i) }

    expect(Algs.speed_score(a0)).to eq(Algs.speed_score(a1))
    expect(Algs.speed_score(a0)).to eq(Algs.speed_score(a2))
    expect(Algs.speed_score(a0)).to eq(Algs.speed_score(a3))
  end

  it 'length' do
    expect(Algs.length("R' F2 L F L' F R")).to eq(7)
    expect(Algs.length("F R' F R F2 L' U2 L")).to eq(8)
    expect(Algs.length("B2 U2 B' U2 B2 U2 B2 U2 B' U2 B2")).to eq(11)
    expect(Algs.length("B' U2 B U B U B2 U' B2 U2 B2 U2 B2 U2 B'")).to eq(15)
  end

  it 'standard_variant' do
    expect(Algs.official_variant("L' B2 R B R' B L")).to eq("B' R2 F R F' R B")
    expect(Algs.official_variant("F' L' U' L U L2 D' L' D L' F2 U' F'")).to eq("B' R' U' R U R2 D' R' D R' B2 U' B'")
    expect(Algs.official_variant("R B U B' U' R'")).to eq("B L U L' U' B'")
    expect(Algs.official_variant("B L U L' U' B'")).to eq("B L U L' U' B'")
    expect(Algs.official_variant("D' F B2")).to eq("D' B F2")
    expect(Algs.official_variant("B' F U R U' R' F' U' B")).to eq("B F' U L U' L' B' U' F")
  end

  it 'standard_u_setup' do
    expect(Algs.standard_u_setup("F' L' U' L U L2 D' L' D L' F2 U' F'")).to eq(0)
    expect(Algs.standard_u_setup("R B2 U' L' B2 R D B2 D' L B2 R' U R'")).to eq(1)
    expect(Algs.standard_u_setup("F U F' U F U2 F'")).to eq(2)
    expect(Algs.standard_u_setup("B' D' F D R2 B2 R2 D' F' D B' U' B2 U' B2")).to eq(3)
  end


end
