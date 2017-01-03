require 'rails_helper'

describe DbAlg do

  it 'Retains information' do
    expect(DbAlg.new("Fup").to_s).to eq("Fup")
    expect(DbAlg.new("P").to_s).to eq("P")

    expect(DbAlg.new("").to_s).to eq("")
    expect(DbAlg.new(nil).to_s).to eq("")
  end

  it 'move_count' do
    expect(DbAlg.new("Fup").move_count).to eq(3)
    expect(DbAlg.new("P").move_count).to eq(1)
    expect(DbAlg.new(nil).move_count).to eq(0)
  end

  it '+' do
    a1 = DbAlg.new("LUF")
    a2 = DbAlg.new("rd")

    expect((a1+a2).to_s).to eq("LUFrd")
    expect((a2+a1).to_s).to eq("rdLUF")
    expect((a1+"qD").to_s).to eq("LUFqD")
  end

  it '[]' do
    da1 = DbAlg.new('1qUBUqnBL')
    expect(da1[1..3].to_s).to eq(DbAlg.new('qUB').to_s)
    expect(da1[4, 2].to_s).to eq(DbAlg.new('Uq').to_s)
  end

  it 'ui_alg' do
    expect(DbAlg.new("Fup").ui_alg.to_s).to eq("F U2 D'")
  end
end