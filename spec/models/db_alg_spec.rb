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

  it 'ui_alg' do
    expect(DbAlg.new("Fup").ui_alg.to_s).to eq("F U2 D'")
  end
end