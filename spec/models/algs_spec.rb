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

  it 'normalize' do
    expect(Algs.normalize("F R2 L2 U D' B F2")).to eq("F L2 R2 D' U B F2")
    expect(Algs.normalize("B L' R F D2 U F B' R")).to eq("B L' R F D2 U B' F R")
  end

  it 'anti_normalize' do
    expect(Algs.anti_normalize("F R2 L2 U D' B F2")).to eq("F R2 L2 U D' F2 B")
    expect(Algs.anti_normalize("B L' R F D2 U F B' R")).to eq("B R L' F U D2 F B' R")
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
    b, r, f, l = "B L F U' F' U L' B'", "R B L U' L' U B' R'", "F R B U' B' U R' F'", "L F R U' R' U F' L'"

    expect(Algs.speed_score(b)).to eq(Algs.speed_score(r))
    expect(Algs.speed_score(b)).to eq(Algs.speed_score(f))
    expect(Algs.speed_score(b)).to eq(Algs.speed_score(l))
  end

  it 'as_b_alg' do
    expect(Algs.as_variant_b("L' B2 R B R' B L")).to eq("B' R2 F R F' R B")
    expect(Algs.as_variant_b("F' L' U' L U L2 D' L' D L' F2 U' F'")).to eq("B' R' U' R U R2 D' R' D R' B2 U' B'")
    expect(Algs.as_variant_b("R B U B' U' R'")).to eq("B L U L' U' B'")
    expect(Algs.as_variant_b("B L U L' U' B'")).to eq("B L U L' U' B'")
    expect(Algs.as_variant_b("D' F B2")).to eq("D' B F2")
  end

  it 'standard_u_setup' do
    expect(Algs.standard_u_setup("F' L' U' L U L2 D' L' D L' F2 U' F'")).to eq(0)
    expect(Algs.standard_u_setup("R B2 U' L' B2 R D B2 D' L B2 R' U R'")).to eq(1)
    expect(Algs.standard_u_setup("F U F' U F U2 F'")).to eq(2)
    expect(Algs.standard_u_setup("B' D' F D R2 B2 R2 D' F' D B' U' B2 U' B2")).to eq(3)
  end


end
