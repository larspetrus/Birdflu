require 'rails_helper'

describe UiAlg do

  it 'Retains information' do
    expect(UiAlg.new("F U2 R'").to_s).to eq("F U2 R'")
    expect(UiAlg.new("U'").to_s).to eq("U'")

    expect(UiAlg.new("").to_s).to eq("")
    expect(UiAlg.new(nil).to_s).to eq("")
  end

  it 'move_count' do
    expect(UiAlg.new("F U2 R'").move_count).to eq(3)
    expect(UiAlg.new("U'").move_count).to eq(1)
    expect(UiAlg.new(nil).move_count).to eq(0)
  end

  it '+' do
    a1 = UiAlg.new("L U F")
    a2 = UiAlg.new("R2 D2")

    expect((a1+a2).to_s).to eq("L U F R2 D2")
    expect((a2+a1).to_s).to eq("R2 D2 L U F")
    expect((a1+"B' D").to_s).to eq("L U F B' D")
  end

  it 'db_alg' do
    expect(UiAlg.new("F U2 D'").db_alg.to_s).to eq("Fup")
  end

end