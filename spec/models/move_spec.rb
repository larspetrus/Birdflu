require 'rails_helper'

describe Move do

  it '#on' do
    expect(Move.on('F')).to eq(Move::F)
    expect(Move.on('L')).to eq(Move::L)
    expect(Move.on(:D)).to eq(Move::D)
  end

  it '#parse' do
    expect(Move.parse("F").side).to eq(:F)
    expect(Move.parse("F").turns).to eq(1)
    expect(Move.parse("D2").side).to eq(:D)
    expect(Move.parse("D2").turns).to eq(2)
    expect(Move.parse("L'").side).to eq(:L)
    expect(Move.parse("L'").turns).to eq(3)
  end

  it '#from' do
    expect(Move.from("F", 1)).to eq("F")
    expect(Move.from("L", 2)).to eq("L2")
    expect(Move.from("B", 3)).to eq("B'")
  end
end