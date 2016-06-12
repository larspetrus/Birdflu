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

  it 'db_alg' do
    expect(UiAlg.new("F U2 D'").db_alg.to_s).to eq("Fup")
  end

end