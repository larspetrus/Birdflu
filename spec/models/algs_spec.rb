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

end
